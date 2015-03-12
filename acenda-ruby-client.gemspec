Gem::Specification.new do |s|
  s.name        = 'acenda-client'
  s.version     = '0.0.1'
  s.date        = '2015-03-12'
  s.summary     = "Acenda client to access the API in Ruby."
  s.description = "HTTP dialog for the Acenda API with the oAuth2 authentication."
  s.authors     = ["Yoann Jaspar"]
  s.email       = 'yoannj@acenda.com'
  s.files       = ["lib/acenda-client.rb"]
  s.homepage    = 'https://github.com/torreycommerce/acenda-ruby-sdk'
  s.add_runtime_dependency "json",
    ["= 1.8.2"]
  s.license     = 'MIT'
end
