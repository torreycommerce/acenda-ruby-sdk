Gem::Specification.new do |s|
  s.name        = 'acenda-ruby-sdk'
  s.version     = '0.0.1'
  s.date        = '2015-03-05'
  s.summary     = "Acenda SDK to access the API"
  s.description = "HTTP dialog for the Acenda API with the oAuth2 authentication."
  s.authors     = ["Yoann Jaspar"]
  s.email       = 'yoannj@acenda.com'
  s.files       = ["lib/acenda-ruby-sdk.rb"]
  s.homepage    = 'http://acenda.com'
  s.add_runtime_dependency "json",
    ["= 1.8.2"]
  s.license     = 'MIT'
end
