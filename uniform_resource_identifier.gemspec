Gem::Specification.new do |s|
  s.author = "Ryan Scott Lewis"
  s.email = "c00lryguy@gmail.com"
  s.homepage = "http://github.com/c00lryguy/uniform_resource_identifier"
  
  s.description = "`uniform_resource_identifier` splits URIs according to RFC 3986 using regexp, attempts to check the public suffix using `public_suffix_service`, and serializes the query string using `active_support` and `addressable`"
  s.summary = "A library to split URIs according to RFC 3986 as closely as possible."
  
  s.require_paths = ["lib"]
  
  s.name = File.basename(__FILE__, ".gemspec")
  s.version = File.read("VERSION")
  
  s.files = Dir['{lib,spec}/**/*']
  
  
end
