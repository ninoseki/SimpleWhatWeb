# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "whatweb/version"

Gem::Specification.new do |spec|
  spec.name          = "SimpleWhatWeb"
  spec.version       = WhatWeb::VERSION
  spec.authors       = ["Manabu Niseki"]
  spec.email         = ["manabu.niseki@gmail.com"]

  spec.summary       = 'Simplified ver. of WhatWeb.'
  spec.description   = 'Simplified ver. of WhatWeb.'
  spec.homepage      = "https://github.com/ninoseki/SimpleWhatWeb"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 4.0"
  spec.add_development_dependency "webmock", "~> 3.4"

  spec.add_dependency "http", "~> 3.3"
  spec.add_dependency "require_all", "~> 2.0"
  spec.add_dependency "sanitize", "~> 4.6"
  spec.add_dependency "thor", "~> 0.19"
end
