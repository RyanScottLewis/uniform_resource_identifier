require 'uniform_resource_identifier/parsable'
require 'uniform_resource_identifier/domain'
require 'active_support/core_ext/hash'
require 'public_suffix_service'

class UniformResourceIdentifier
  class Host
    extend Parsable
    
    def initialize(host=nil)
      if host.respond_to?(:to_str) 
        begin
          pss = PublicSuffixService.parse(host)
          
          @subdomain = pss.trd
          @domain = Domain.new(:sld => pss.sld, :tld => pss.tld)
        rescue PublicSuffixService::DomainInvalid
          # We couldn't parse your tld (public suffix) =(
          @domain = Domain.new(:sld => nil, :tld => host) # TODO: is this proper? see Domain#to_s
        end
      elsif host.respond_to?(:to_hash)
        host = host.to_hash.symbolize_keys
        
        @subdomain = host[:subdomain]
        @domain = Domain.new(host[:domain])
      else
        raise(TypeError, "host must either be a String or a Hash") unless host.blank?
      end
    end
    
    def to_s
      subdomain = "#{@subdomain}." unless @subdomain.nil?
      "#{subdomain}#{@domain}"
    end
    
    def to_h
      {
        :subdomain => @subdomain,
        :domain    => @domain.nil? ? nil : @domain.to_h
      }
    end
    
    def blank?
      @subdomain.blank && @domain.blank?
    end
    
    # ======================================================================= #
    # = Attributes                                                          = #
    # ======================================================================= #
    
    attr_reader :subdomain
    
    def subdomain=(subdomain)
      @subdomain = subdomain.nil? ? subdomain : subdomain.to_s
    end
    
    def domain
      @domain ||= Domain.new
    end
    
    def domain=(domain)
      @domain = Domain.parse(domain)
    end
    
    # ======================================================================= #
    # = Delegates                                                           = #
    # ======================================================================= #
    
    def sld
      self.domain.sld
    end
    
    def sld=(sld)
      self.domain.sld = sld
    end
    
    def tld
      self.domain.tld
    end
    
    def tld=(tld)
      self.domain.tld = tld
    end
  end
end