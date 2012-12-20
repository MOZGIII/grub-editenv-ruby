# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grub-editenv-ruby/version'

Gem::Specification.new do |gem|
  gem.name          = "grub-editenv-ruby"
  gem.version       = GrubEditEnv::VERSION
  gem.authors       = ["MOZGIII"]
  gem.email         = ["mike-n@narod.ru"]
  gem.description   = %q{Ruby version of grub-editenv command line utility.}
  gem.summary       = %q{Allows you to edit grubenv without having grub-editenv installed.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'bundler', '~> 1.0'
end
