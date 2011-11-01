require 'uniform_resource_identifier/parsable'
require 'active_support/core_ext/hash'
require 'public_suffix_service'

class UniformResourceIdentifier
  class Domain
    extend Parsable
    
    def initialize(domain=nil)
      if domain.respond_to?(:to_str) 
        begin
          pss = PublicSuffixService.parse(domain)
          
          @sld, @tld = pss.sld, pss.tld
        rescue PublicSuffixService::DomainInvalid
          # We couldn't parse your tld (public suffix) =(
          @tld = domain
        end
      elsif domain.respond_to?(:to_hash)
        domain.to_hash.symbolize_keys
        @sld, @tld = domain.values_at(:sld, :tld)
      else
        raise(TypeError, "domain must either be a String or a Hash") unless domain.nil?
      end
    end
    
    def to_s
      sld = "#{@sld}." unless @sld.nil?
      "#{sld}#{@tld}"
    end
    
    def to_h
      { :sld => @sld, :tld => @tld }
    end
    
    def blank?
      @sld.blank? && @tld.blank?
    end
    
    # ======================================================================= #
    # = Attributes                                                          = #
    # ======================================================================= #
    
    attr_reader :sld
    attr_reader :tld
    
    def sld=(sld)
      @sld = sld.nil? ? nil : sld.to_s
    end
    
    def tld=(tld)
      @tld = tld.nil? ? nil : tld.to_s
    end
  end
end