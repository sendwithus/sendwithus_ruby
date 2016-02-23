# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'send_with_us/version'

Gem::Specification.new do |gem|
  gem.name          = "send_with_us"
  gem.version       = SendWithUs::VERSION
  gem.authors       = ["Matt Harris", "Chris Cummer", "Nicholas Rempel", "Gregory Schier", "Brad Van Vugt"]
  gem.email         = ["us@sendwithus.com"]
  gem.description   = %q{SendWithUs.com Ruby Client}
  gem.summary       = %q{SendWithUs.com Ruby Client}
  gem.homepage      = "https://github.com/sendwithus/sendwithus_ruby"
  gem.license       = "Apache-2.0"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'shoulda'
  gem.add_development_dependency 'mocha'
end
