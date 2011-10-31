require 'uniform_resource_identifier/parsable'
require 'uniform_resource_identifier/parser'
require 'uniform_resource_identifier/host'
require 'uniform_resource_identifier/user_info'
require 'active_support/core_ext/hash'

class UniformResourceIdentifier
  class Authority
    extend Parsable
    
    def initialize(authority=nil)
      if authority.respond_to?(:to_str)
        authority = Parser.parse(authority)
        
        @user_info = UserInfo.parse(authority[:user_info]) if authority.has_key?(:user_info)
        @host = Host.parse(authority[:host]) if authority.has_key?(:host)
        @port = authority[:port].to_i if authority.has_key?(:port)
      elsif authority.respond_to?(:to_hash)
        authority = authority.to_hash.symbolize_keys
        
        @user_info = UserInfo.parse(authority[:user_info]) if authority.has_key?(:user_info)
        @host = Host.parse(authority[:host]) if authority.has_key?(:host)
        @port = authority[:port].to_i if authority.has_key?(:port)
      else
        raise(TypeError, "authority must either be a String or a Hash") unless authority.nil?
      end
    end
    
    def to_s
      user_info = "#{@user_info}@" unless @user_info.blank?
      port = ":#{@port}" unless @port.blank? || @port == 0 # TODO: Should match 0?
      "#{user_info}#{@host}#{port}"
    end
    
    def to_h
      {
        :user_info => user_info.nil? ? nil : @user_info.to_h,
        :host      => host.nil? ? nil : @host.to_h,
        :port      => @port
      }
    end
    
    # ======================================================================= #
    # = Attributes                                                          = #
    # ======================================================================= #
    
    def user_info
      @user_info ||= UserInfo.new
    end
    
    def user_info=(user_info)
      @user_info = UserInfo.parse(user_info)
    end
    
    def host
      @host ||= Host.new
    end
    
    def host=(host)
      @host = Host.parse(user_info)
    end
    
    attr_reader :port
    
    def port=(port)
      @port = port.to_i
    end
    
    # ======================================================================= #
    # = Delegates                                                           = #
    # ======================================================================= #
    
    def username
      self.user_info.username
    end
    
    def username=(username)
      self.user_info.username = username
    end
    
    def password
      self.user_info.password
    end
    
    def password=(password)
      self.user_info.password = password
    end
    
    def subdomain
      self.host.subdomain
    end
    
    def subdomain=(subdomain)
      self.host.subdomain = subdomain
    end
    
    def domain
      self.host.domain ||= Domain.new
    end
    
    def domain=(domain)
      self.host.domain = Domain.parse(domain)
    end
    
    def sld
      self.host.domain.sld
    end
    
    def sld=(sld)
      self.host.domain.sld = sld
    end
    
    def tld
      self.host.domain.tld
    end
    
    def tld=(sld)
      self.host.domain.tld = tld
    end
  end
end
