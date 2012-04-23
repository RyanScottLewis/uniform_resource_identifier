require 'uniform_resource_identifier/parsable'
require 'uniform_resource_identifier/parser'
require 'active_support/core_ext/hash'

class UniformResourceIdentifier
  
  class Path
    extend Parsable
    
    def initialize(path=nil)
      if path.respond_to?(:to_str) 
        parsed_uri = Parser.parse(path)
        @directory, @file = parsed_uri.values_at(:directory, :file)
      elsif path.respond_to?(:to_hash)
        path.to_hash.symbolize_keys
        @directory, @file = path.values_at(:directory, :file)
      else
        raise(TypeError, "path must either be a String or a Hash") unless path.nil?
      end
    end
    
    def to_s
      "#{@directory}#{@file}#{@file.nil? ? nil : @extension}"
    end
    
    def to_h
      {
        :directory => @directory,
        :file => @file
      }
    end
    
    def blank?
      @directory.blank? && @file.blank?
    end
    
    # ======================================================================= #
    # = Attributes                                                          = #
    # ======================================================================= #
    
    attr_reader :directory
    attr_reader :file
    
    def extension
      ext = File.extname(@file)
      @extension ||= ext unless ext.empty?
      @extension
    end
    
    def directory=(directory)
      @directory = directory.nil? ? nil : directory.to_s
    end
    
    def file=(file)
      @file = file.nil? ? nil : file.to_s
    end
    
    def extension=(extension)
      @extension = extension.nil? ? nil : extension.to_s
    end
  end
end