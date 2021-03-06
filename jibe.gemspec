# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jibe/version'

Gem::Specification.new do |spec|
  spec.name          = "jibe"
  spec.version       = Jibe::VERSION
  spec.authors       = ["cj"]
  spec.email         = ["cjlazell@gmail.com"]
  spec.description   = %q{Using sidekiq to keep data synced accross multuple systems.}
  spec.summary       = %q{sync data between multiple applications}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 4.0.2"
  spec.add_dependency "sidekiq", ">= 2.17.3"
  spec.add_dependency "zopfli"
  spec.add_dependency "recursive-open-struct"
  spec.add_dependency "hooks"
  spec.add_dependency "encryptor"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "turnip"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv-rails"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "database_cleaner"
end
