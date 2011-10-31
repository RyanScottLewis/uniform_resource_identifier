require 'uniform_resource_identifier/parsable'
require 'active_support/core_ext/object/to_query'
require 'addressable/uri'

class UniformResourceIdentifier
  class Query
    extend Parsable
    
    def initialize(query)
      if query.respond_to?(:to_str)
        query = "#{query =~ /^\?/ ? nil : '?'}#{query.to_str}" # Prepend a question mark if needed
        @query = Addressable::URI.parse(query).query_values
      elsif query.respond_to?(:to_hash)
        @query = query.to_hash
      else
        raise(TypeError, "query must either be a String or a Hash") unless query.nil?
      end
    end
    
    def to_s
      @query.to_query
    end
    
    def to_h
      @query
    end
  end
end
