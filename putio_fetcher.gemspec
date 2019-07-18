lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "putio_fetcher/version"

Gem::Specification.new do |spec|
  spec.name          = "putio_fetcher"
  spec.version       = PutioFetcher::VERSION
  spec.authors       = ["Rafael Biriba"]
  spec.email         = ["biribarj@gmail.com"]

  spec.summary       = "Put.io download script! The easiest way to have all all your put.io files locally."
  spec.description   = "Put.io download script! The easiest way to have all all your put.io files locally."
  spec.homepage      = "https://github.com/rafaelbiriba/putio_fetcher"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rafaelbiriba/putio_fetcher"
  spec.metadata["changelog_uri"] = "https://github.com/rafaelbiriba/putio_fetcher/blob/master/CHANGELOG.md"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
