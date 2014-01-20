require "sidekiq"
require 'zlib'
require "zopfli"
require "base64"
require "encryptor"
require "hooks"
require "recursive-open-struct"
require "jibe/version"
require "jibe/model"
require "jibe/worker"
require "jibe/model_worker"

if defined? Rails
  require "jibe/engine"
end

module Jibe
  extend self

  attr_accessor :config, :client, :systems

  def config
    @config ||= OpenStruct.new
  end

  def setup
    yield config
  end

  def add_systems *systems

  end

  def system
    config.system.to_sym
  end

  def secret
    config.secret
  end

  def compress object
    Base64.encode64(Zopfli.deflate object.marshal_dump.to_json)
  end

  def decompress string
    RecursiveOpenStruct.new(
      JSON.parse Zlib::Inflate.inflate(Base64.decode64(string))
    )
  end

  def encrypt string
    Encryptor.encrypt(string, key: secret, salt: salt(string))
  end

  def decrypt string
    begin
      Encryptor.decrypt(string, key: secret, salt: salt(string))
    rescue
      false
    end
  end

  def compress_and_encrypt object
    Base64.encode64 encrypt compress(object)
  end

  def decrypt_and_decompress string
    decompress decrypt(Base64.decode64 string)
  end

  def salt string
    config.salt || "#{string}jibe#{system}"
  end

  def iv
    OpenSSL::Cipher::Cipher.new('aes-256-cbc').random_iv
  end
end
