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
  
  # Add files you *might* use in ALL projects! The point is to never need to change.
  %W{Gemfile.lock *.gemspec README.* README Rakefile VERSION LICENSE}.each do |file|
    s.files.unshift(file) if File.exists?(file)
  end
  
  # Add files you *might* use in ALL projects! The point is to never need to change.
  %W{README.* README VERSION LICENSE}.each do |file|
    (s.extra_rdoc_files ||= []).unshift(file) if File.exists?(file)
  end
  
  s.test_files = Dir['{bin,spec}/**/*']
  
  s.add_dependency("public_suffix", "~> 1.1")
  s.add_dependency("activesupport", ">= 3.0")
  s.add_dependency("addressable", "~> 2.2")
  s.add_dependency('i18n', '~> 0.6')
  
  s.add_development_dependency("bundler", "~> 1.0")
  s.add_development_dependency("rspec", "~> 2.6")
  s.add_development_dependency("watchr", "~> 0.7")
end