# -*- encoding: utf-8 -*-
require File.expand_path('../lib/http_machinegun/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["y.fujii"]
  gem.email         = ["ishikurasakura@gmail.com"]
  gem.description   = %q{http client with thread}
  gem.summary       = %q{send data with thread}
  gem.homepage      = "https://github.com/YoshitsuguFujii/http_machinegun"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "http_machinegun"
  gem.require_paths = ["lib"]
  gem.version       = HttpMachinegun::VERSION

  gem.add_dependency 'thor'
  gem.add_dependency 'parallel'
end
