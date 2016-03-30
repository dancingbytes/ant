# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ant/version'

Gem::Specification.new do |spec|
  spec.name          = "ant"
  spec.version       = Ant::VERSION
  spec.authors       = ["Ivan Piliaev (Tyralion)"]
  spec.email         = ["piliaiev@gmail.com"]

  spec.summary       = %q{BBcode editor for Rails}
  spec.description   = %q{BBcode editor for Rails}
  spec.homepage      = "https://github.com/dancingbytes/ant"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.license       = "BSD"
  spec.add_runtime_dependency "railties", ">= 3.2", "< 5"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"

end
