module Jibe
  class Engine < Rails::Engine
    initializer "jibe.activerecord" do
      ActiveRecord::Base.send :include, Model
    end
  end
end
