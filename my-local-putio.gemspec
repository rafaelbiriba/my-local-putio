lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "my-local-putio/version"

Gem::Specification.new do |spec|
  spec.name          = "my-local-putio"
  spec.version       = MyLocalPutio::VERSION
  spec.authors       = ["Rafael Biriba"]
  spec.email         = ["biribarj@gmail.com"]

  spec.summary       = "The easiest script to synchronise all your put.io files locally."
  spec.description   = "The easiest script to synchronise all your put.io files locally."
  spec.homepage      = "https://github.com/rafaelbiriba/my-local-putio"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rafaelbiriba/my-local-putio"
  spec.metadata["changelog_uri"] = "https://github.com/rafaelbiriba/my-local-putio/blob/master/CHANGELOG.md"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_dependency "socksify", "1.7.1"
end
