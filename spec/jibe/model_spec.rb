require 'spec_helper'

describe Jibe::Model do
  it 'should allow you to jibe certain fields' do
    User.create first_name: 'foo', last_name: 'bar'
  end
end
