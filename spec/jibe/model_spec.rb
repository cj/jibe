require 'spec_helper'

describe Jibe::Model do
  let(:user) { User.create(first_name: 'foo', last_name: 'bar') }

  before do
    Sidekiq::Testing.inline!

    Jibe.setup do |config|
      config.redis  = { url: 'redis://localhost:6379' }
      config.system = :test1
      config.secret = '123456'
    end

    Jibe.stub(:systems).and_return [:test1, :test2]
  end

  # Clear jobs
  after { Jibe::ModelWorker.clear }

  it 'should allow you to jibe certain fields' do
    user_hash = user.jibe_object.to_h

    expect(user_hash.keys).to include(
      :id,
      :id_was,
      :first_name,
      :first_name_was,
      :last_name,
      :last_name_was
    )

    expect(user_hash.keys).not_to include :age, :age_was
  end

  it 'should queue a job for the model' do
    Sidekiq::Testing.fake!
    user
    expect(Jibe::ModelWorker.jobs.size).to eq 1
  end

  it 'should trigger jibe callbacks and add a second record' do
    user
    expect(User.count).to eq 2
  end
end
