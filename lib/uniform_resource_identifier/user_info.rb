require 'uniform_resource_identifier/parsable'
require 'active_support/core_ext/hash'

class UniformResourceIdentifier
  class UserInfo
    extend Parsable
    
    def initialize(user_info=nil)
      if user_info.respond_to?(:to_str) 
        @username, @password = user_info.to_str.split(":")
      elsif user_info.respond_to?(:to_hash)
        user_info.to_hash.symbolize_keys
        @username, @password = user_info.values_at(:username, :password)
      else
        raise(TypeError, "user_info must either be a String or a Hash") unless user_info.nil?
      end
    end
    
    def to_s
      "#{@username}:#{@password}"
    end
    
    def to_h
      {
        :username => @username,
        :password => @password
      }
    end
    
    def blank?
      @username.blank? && @password.blank?
    end
    # ======================================================================= #
    # = Attributes                                                          = #
    # ======================================================================= #
    
    attr_reader :username
    attr_reader :password
    
    def username=(username)
      @username = username.nil? ? username : username.to_s
    end
    
    def password=(password)
      @password = password.nil? ? password : password.to_s
    end
  end
end