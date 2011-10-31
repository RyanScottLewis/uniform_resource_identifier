require 'pathname'
__LIB__ = Pathname.new(__FILE__).dirname.expand_path
$:.unshift(__LIB__.to_s) unless $:.include?(__LIB__.to_s)

require 'uniform_resource_identifier/authority'
require 'uniform_resource_identifier/relative'

class UniformResourceIdentifier
  extend Parsable
  
  def initialize(uri=nil)
    if uri.respond_to?(:to_str)
      parsed_uri = Parser.parse(uri)
      
      @protocol = parsed_uri[:protocol]
      
      @authority = Authority.new(
        :user_info => {
          :username => parsed_uri[:username],
          :password => parsed_uri[:password]
        },
        :host => parsed_uri[:host],
        :port => parsed_uri[:port]
      )
      
      @relative = Relative.new(
        :path => {
          :directory => parsed_uri[:directory],
          :file => parsed_uri[:file]
        },
        :query => parsed_uri[:query],
        :anchor => parsed_uri[:anchor]
      )
    elsif uri.respond_to?(:to_hash)
      uri = uri.to_hash.symbolize_keys
      
      @protocol = uri[:protocol].to_s if uri.has_key?(:protocol)
      @authority = Authority.parse(uri[:authority]) if uri.has_key?(:authority)
      @relative = Relative.parse(uri[:relative]) if uri.has_key?(:relative)
    else
      raise(TypeError, "uri must either be a String or a Hash") unless uri.nil?
    end
  end
  
  def to_s
    protocol = "#{@protocol}://" unless @protocol.nil?
    "#{protocol}#{@authority}#{@relative}"
  end
  
  def to_h
    {
      :protocol => @protocol,
      :authority => @authority.nil? ? nil : @authority.to_h,
      :relative => @relative.nil? ? nil : @relative.to_h
    }
  end
  
  # ======================================================================= #
  # = Attributes                                                          = #
  # ======================================================================= #
  
  attr_reader :protocol
  
  def protocol=(protocol)
    @protocol = protocol.nil? ? nil : protocol.to_s
  end
  
  alias_method :scheme, :protocol
  alias_method :scheme=, :protocol=
  
  def authority
    @authority ||= Authority.new
  end
  
  def authority=(authority)
    @authority = Authority.parse(authority)
  end
  
  def relative
    @relative ||= Relative.new
  end
  
  def relative=(relative)
    @relative = Relative.parse(relative)
  end
  
  # ======================================================================= #
  # = Delegates                                                           = #
  # ======================================================================= #
  
  def user_info
    self.authority.user_info
  end
  
  def user_info=(user_info)
    self.authority.user_info = user_info
  end
  
  def username
    self.authority.user_info.username
  end
  
  def username=(username)
    self.authority.user_info.username = username
  end
  
  def password
    self.authority.user_info.password
  end
  
  def password=(password)
    self.authority.user_info.password = password
  end
  
  def host
    self.authority.host
  end
  
  def host=(host)
    self.authority.host = host
  end
  
  def subdomain
    self.authority.host.subdomain
  end
  
  def subdomain=(subdomain)
    self.authority.host.subdomain = subdomain
  end
  
  def domain
    self.authority.host.domain ||= Domain.new
  end
  
  def domain=(domain)
    self.authority.host.domain = Domain.parse(domain)
  end
  
  def sld
    self.authority.host.domain.sld
  end
  
  def sld=(sld)
    self.authority.host.domain.sld = sld
  end
  
  def tld
    self.authority.host.domain.tld
  end
  
  def tld=(sld)
    self.authority.host.domain.tld = tld
  end
  
  def port
    self.authority.port
  end
  
  def port=(port)
    self.authority.port = port
  end
  
  def path
    self.relative.path
  end
  
  def path=(path)
    self.relative.path = path
  end
  
  def directory
    self.relative.path.directory
  end
  
  def directory=(directory)
    self.relative.path.directory = directory
  end
  
  def file
    self.relative.path.file
  end
  
  def file=(file)
    self.relative.path.file = file
  end
  
  def query
    self.relative.query
  end
  
  def query=(query)
    self.relative.query = query
  end
  
  def anchor
    self.relative.anchor
  end
  
  def anchor=(anchor)
    self.relative.anchor = anchor
  end
  
  # ======================================================================= #
  # = Extras                                                              = #
  # ======================================================================= #
  
  def relative?
    self.host.nil?
  end
  
  def absolute?
    !relative?
  end
  
  def localhost?
    !!(self.host =~ /^localhost$/i)
  end
end
