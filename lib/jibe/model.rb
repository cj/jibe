module Jibe
  module Model
    extend ActiveSupport::Concern

    def self.const_missing name
      const_set name, Class.new(name.to_s.classify.constantize)
    end

    included do
      include Hooks
      include Hooks::InstanceHooks

      attr_accessor :jibe_off, :jibe_dup, :jibe_object, :jibe_id_was
      define_hooks :jibe_on_create, :jibe_on_update, :jibe_on_destroy
    end

    module ClassMethods
      def jibe(actions)
        before_save do
          return if jibe_off

          @jibe_dup             = self.dup
          @jibe_dup.jibe_id_was = id
        end

        after_commit do
          return if jibe_off

          @jibe_dup.id = id
          @jibe_object = OpenStruct.new

          actions.each do |key, data|
            case key
            when :on; jibe_process_on(actions, data) end
          end

          model_name       = self.class.model_name.singular
          encrypted_string = Jibe.compress_and_encrypt jibe_object

          if transaction_record_state :new_record
            action = :create
          elsif transaction_record_state :destroyed
            action = :destroy
          else
            action = :update
          end

          Jibe.systems.each do |system|
            system = system.to_sym
            next if Jibe.system == system

            Sidekiq::Client.push({
              'class' => Jibe::ModelWorker,
              'queue' => Jibe.system,
              'args'  => [system, model_name, action, encrypted_string]
            })
          end
        end
      end
    end

    def jibe_process_on actions, data
      if id = jibe_dup.send(:id)
        jibe_object.id     = id
        jibe_object.id_was = jibe_dup.jibe_id_was
      end

      data.each do |field|
        field_was = "#{field}_was"

        jibe_object[field]     = jibe_dup.send(field)
        jibe_object[field_was] = jibe_dup.send(field_was)
      end
    end
  end
end
