# frozen_string_literal: true

require_relative "lib/lingy/version"

Gem::Specification.new do |spec|
  spec.name          = "lingy"
  spec.version       = Lingy::VERSION
  spec.authors       = ["Ingy döt Net"]
  spec.email         = ["ingy@ingy.net"]

  spec.summary       = "Program in YAML"
  spec.description   = "Program in YAML"
  spec.homepage      = "https://github.com/ingydotnet/lingy"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/ingydotnet/lingy/tree/main/ruby/ChangeLog.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "hamster", "~> 3.0"
  spec.add_dependency "concurrent-ruby", "~> 1.2.2"
  spec.add_dependency "zeitwerk"
end
