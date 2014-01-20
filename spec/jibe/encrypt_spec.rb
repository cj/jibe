require 'spec_helper'

describe 'Jibe Encryption' do
  let(:encrypted) { Jibe.encrypt('moo') }

  before do
    Jibe.setup do |config|
      config.system = :test1
      config.secret = '123456'
    end
  end

  it 'should decrypt the string' do
    expect(Jibe.decrypt(encrypted)).to eq 'moo'
  end

  it 'should not decrypt the string if the secret is wrong' do
    string = encrypted
    # set an incorrect secret
    Jibe.setup { |config| config.secret = '654321' }

    expect(Jibe.decrypt(string)).not_to eq 'moo'
  end
end
