print "#{RUBY_VERSION} - #{RUBY_PLATFORM} - #{RUBY_RELEASE_DATE} -=- "

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'uniform_resource_identifier'
require 'uniform_resource_identifier/rspec_matcher'
