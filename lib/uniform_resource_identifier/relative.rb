require 'uniform_resource_identifier/parsable'
require 'uniform_resource_identifier/parser'
require 'uniform_resource_identifier/path'
require 'uniform_resource_identifier/query'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/object/blank'

class UniformResourceIdentifier
  class Relative
    extend Parsable
    
    def initialize(relative=nil)
      if relative.respond_to?(:to_str)
        parsed_uri = Parser.parse(relative)
        # TODO
      elsif relative.respond_to?(:to_hash)
        relative = relative.to_hash.symbolize_keys
        
        @path = Path.parse(relative[:path]) if relative.has_key?(:path)
        @query = Query.parse(relative[:query]) if relative.has_key?(:query)
        @anchor = relative[:anchor].to_s.gsub(/^#/, '') if relative.has_key?(:anchor)
      else
        raise(TypeError, "relative must either be a String or a Hash") unless relative.nil?
      end
    end
    
    def to_s
      query = "/#{@path}" if @path.blank? || !@path.to_s.starts_with?("/")
      query = "?#{@query}" unless @query.blank?
      anchor = "##{@anchor}" unless @anchor.blank?
      "#{path}#{query}#{anchor}"
    end
    
    def to_h
      {
        :path   => path.nil? ? nil : @path.to_h,
        :query  => query.nil? ? nil : @query.to_h,
        :anchor => @anchor
      }
    end
    
    def blank?
      @path.blank? && @query.blank? && @anchor.blank?
    end
    
    # ======================================================================= #
    # = Attributes                                                          = #
    # ======================================================================= #
    
    def path
      @path ||= Path.new
    end
    
    def path=(path)
      @path = Path.parse(path)
    end
    
    def query
      @query ||= Query.new
    end
    
    def query=(query)
      @query = Query.parse(query)
    end
    
    attr_reader :anchor
    
    def anchor=(anchor)
      @anchor = anchor.nil? ? nil : anchor.to_s
    end
    
    # ======================================================================= #
    # = Delegates                                                           = #
    # ======================================================================= #
    
    def directory
      self.path.directory
    end
    
    def directory=(directory)
      self.path.directory = directory
    end
    
    def file
      self.path.file
    end
    
    def file=(file)
      self.path.file = file
    end
  end
end