module Jibe
  class Engine < Rails::Engine
    initializer "jibe.activerecord" do
      ActiveRecord::Base.send :extend, Model::ClassMethods
    end
  end
end
