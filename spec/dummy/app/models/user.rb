class User < ActiveRecord::Base
  jibe on: [:first_name, :last_name]
end

