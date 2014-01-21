class User < ActiveRecord::Base
  jibe on: [:first_name, :last_name]

  jibe_on_create do |user|
    attributes = user.to_h.select do |field, value|
      %w(first_name last_name).include? field.to_s
    end

    Jibe::Model::User.create attributes
  end
end

