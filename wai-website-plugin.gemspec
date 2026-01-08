# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "wai-website-plugin"
  spec.version       = "0.3"
  spec.authors       = ["Eric Eggert", "Rémi Bétin"]
  spec.email         = ["wai@w3.org"]

  spec.summary       = "Plugin used for the W3C WAI website"
  spec.homepage      = "https://github.com/w3c/wai-website-plugin"
  spec.license       = "Nonstandard"

  spec.files         = ["lib/wai-website-plugin.rb", "lib/wai-website-plugin/heading-id-filter.rb", "lib/wai-website-plugin/links-hooks.rb"]

  spec.required_ruby_version = ">= 3.3.3"

  spec.add_runtime_dependency "jekyll", "~>4.4.1"
  spec.add_runtime_dependency "nokogiri", '~>1.19.0'
end
