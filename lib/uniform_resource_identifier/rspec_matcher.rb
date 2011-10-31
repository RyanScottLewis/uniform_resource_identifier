RSpec::Matchers.define(:have_uri_specification) do |uri_specification|
  match do |uri_string|
    url = UniformResourceIdentifier.parse(uri_string)
    
    # ======================================================================= #
    # = Protocol/Scheme                                                     = #
    # ======================================================================= #
    
    url.protocol.class.should == String
    url.protocol.to_s.should == uri_specification[:protocol]
    url.scheme.class.should == String                      # Alias
    url.scheme.to_s.should == uri_specification[:protocol] # Alias
    
    # ======================================================================= #
    # = Authority                                                           = #
    # ======================================================================= #
    
    url.authority.class.should == UniformResourceIdentifier::Authority
    url.authority.to_s.should == uri_specification[:authority]
    
    url.authority.user_info.class.should == UniformResourceIdentifier::UserInfo
    url.authority.user_info.to_s.should == uri_specification[:user_info]
    url.user_info.class.should == UniformResourceIdentifier::UserInfo # Delegate
    url.user_info.to_s.should == uri_specification[:user_info]        # Delegate
    
    url.authority.user_info.username.class.should == String
    url.authority.user_info.username.to_s.should == uri_specification[:username]
    url.user_info.username.class.should == String                      # Delegate
    url.user_info.username.to_s.should == uri_specification[:username] # Delegate
    url.username.class.should == String                                # Delegate
    url.username.to_s.should == uri_specification[:username]           # Delegate
    
    url.authority.user_info.password.class.should == String
    url.authority.user_info.password.to_s.should == uri_specification[:password]
    url.user_info.password.class.should == String                      # Delegate
    url.user_info.password.to_s.should == uri_specification[:password] # Delegate
    url.password.class.should == String                                # Delegate
    url.password.to_s.should == uri_specification[:password]           # Delegate
    
    url.authority.host.class.should == UniformResourceIdentifier::Host
    url.authority.host.to_s.should == uri_specification[:host]
    url.host.class.should == UniformResourceIdentifier::Host # Delegate
    url.host.to_s.should == uri_specification[:host]         # Delegate
    
    url.authority.host.subdomain.class.should == String
    url.authority.host.subdomain.to_s.should == uri_specification[:subdomain]
    url.host.subdomain.class.should == String                       # Delegate
    url.host.subdomain.to_s.should == uri_specification[:subdomain] # Delegate
    url.subdomain.class.should == String                            # Delegate
    url.subdomain.to_s.should == uri_specification[:subdomain]      # Delegate
    
    url.authority.host.domain.class.should == UniformResourceIdentifier::Domain
    url.authority.host.domain.to_s.should == uri_specification[:domain]
    url.host.domain.class.should == UniformResourceIdentifier::Domain # Delegate
    url.host.domain.to_s.should == uri_specification[:domain]         # Delegate
    url.domain.class.should == UniformResourceIdentifier::Domain      # Delegate
    url.domain.to_s.should == uri_specification[:domain]              # Delegate
    
    url.authority.host.domain.sld.class.should == String
    url.authority.host.sld.to_s.should == uri_specification[:sld]
    url.host.sld.class.should == String                 # Delegate
    url.host.sld.to_s.should == uri_specification[:sld] # Delegate
    url.sld.class.should == String                      # Delegate
    url.sld.to_s.should == uri_specification[:sld]      # Delegate
    
    url.authority.host.domain.tld.class.should == String
    url.authority.host.tld.to_s.should == uri_specification[:tld]
    url.host.tld.class.should == String                 # Delegate
    url.host.tld.to_s.should == uri_specification[:tld] # Delegate
    url.tld.class.should == String                      # Delegate
    url.tld.to_s.should == uri_specification[:tld]      # Delegate
    
    url.authority.port.class.should == Fixnum
    url.authority.port.to_s.should == uri_specification[:port]
    url.port.class.should == Fixnum                  # Delegate
    url.port.to_s.should == uri_specification[:port] # Delegate
    
    # ======================================================================= #
    # = Relative                                                            = #
    # ======================================================================= #
    
    url.relative.class.should == UniformResourceIdentifier::Relative
    url.relative.to_s.should == uri_specification[:relative]
    
    url.relative.path.class.should == UniformResourceIdentifier::Path
    url.relative.path.to_s.should == uri_specification[:path]
    url.path.class.should == UniformResourceIdentifier::Path # Delegate
    url.path.to_s.should == uri_specification[:path]         # Delegate
    
    url.relative.path.directory.class.should == String
    url.relative.path.directory.to_s.should == uri_specification[:directory]
    url.relative.directory.class.should == String                       # Delegate
    url.relative.directory.to_s.should == uri_specification[:directory] # Delegate
    url.directory.class.should == String                                # Delegate
    url.directory.to_s.should == uri_specification[:directory]          # Delegate
    
    url.relative.path.file.class.should == String
    url.relative.path.file.to_s.should == uri_specification[:file]
    url.relative.file.class.should == String                       # Delegate
    url.relative.file.to_s.should == uri_specification[:file]      # Delegate
    url.file.class.should == String                                # Delegate
    url.file.to_s.should == uri_specification[:file]               # Delegate
    
    url.relative.query.class.should == UniformResourceIdentifier::Query
    url.relative.query.to_s.should == uri_specification[:query]
    url.query.class.should == UniformResourceIdentifier::Query # Delegate
    url.query.to_s.should == uri_specification[:query]         # Delegate
    
    url.relative.anchor.class.should == String
    url.relative.anchor.to_s.should == uri_specification[:anchor]
    url.anchor.class.should == String                    # Delegate
    url.anchor.to_s.should == uri_specification[:anchor] # Delegate
  end
end