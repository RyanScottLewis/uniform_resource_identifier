# uniform_resource_identifier

`uniform_resource_identifier` is a library to split URIs 
according to RFC 3986 as closely as possible. 

Note that by design, this does not attempt to validate 
the URI it receives, as that would limit its flexibility.

## Install

Simply drop the following line into your Gemfile:

    gem 'uniform_resource_identifier', '~> 0.1'

Or install through RubyGems:

    gem install uniform_resource_identifier

## Usage

```ruby
    require 'uniform_resource_identifier'
    
    url = "foo://usr:pwd@www.example.co.uk:8042/over/there.htm?name=ferret#nose"
    uri = UniformResourceIdentifier.parse(url)
    
    uri.protocol                      # => "foo"
    
    uri.authority.to_s                # => "usr:pwd@www.example.co.uk:8042"
    
    uri.authority.user_info.to_s      # => "usr:pwd"
    uri.user_info.to_s                # => "usr:pwd"
    
    uri.authority.user_info.username  # => "usr"
    uri.authority.user_info.password  # => "pwd"
    uri.user_info.username            # => "usr"
    uri.user_info.password            # => "pwd"
    uri.username                      # => "usr"
    uri.password                      # => "pwd"
    
    uri.authority.host.to_s           # => "www.example.co.uk"
    uri.host.to_s                     # => "www.example.co.uk"
    
    uri.authority.host.subdomain      # => "www"
    uri.authority.subdomain           # => "www"
    uri.subdomain                     # => "www"
    
    uri.authority.host.domain.to_s    # => "example.co.uk"
    uri.authority.domain.to_s         # => "example.co.uk"
    uri.domain.to_s                   # => "example.co.uk"
    
    uri.authority.host.domain.sld     # => "example"
    uri.authority.domain.sld          # => "example"
    uri.domain.sld                    # => "example"
    uri.sld                           # => "example"
    
    uri.authority.host.domain.tld     # => "co.uk"
    uri.authority.domain.tld          # => "co.uk"
    uri.domain.tld                    # => "co.uk"
    uri.tld                           # => "co.uk"
    
    uri.authority.port                # => 8042
    uri.port                          # => 8042
    
    uri.relative.to_s                 # => "/over/there.htm?name=ferret#nose"
    
    uri.relative.path.to_s            # => "/over/there.htm"
    uri.path.to_s                     # => "/over/there.htm"
    
    uri.relative.path.directory.to_s  # => "/over/"
    uri.relative.directory.to_s       # => "/over/"
    uri.directory.to_s                # => "/over/"
    
    uri.relative.path.file.to_s       # => "there.htm"
    uri.relative.file.to_s            # => "there.htm"
    uri.file.to_s                     # => "there.htm"
    
    uri.relative.query                # => { "name" => "ferret" }
    uri.query                         # => { "name" => "ferret" }
    
    uri.relative.anchor               # => "nose"
    uri.anchor                        # => "nose"
```

## URI Graph

    +---------------+------------------------------------------------------------------------+
    | Legend        | Graph                                                                  |
    +===============+========================================================================+
    | protocol      |                                                                        |
    | authority     |   foo://usr:pwd@www.example.co.uk:8042/over/there.htm?name=ferret#nose |
    |   user_info   |   \_/   \____________________________/\______________________________/ |
    |     username  |    |                 |                               |                 |
    |     password  | protocol         authority                        relative             |
    |   host        |                                                                        |
    |     subdomain +------------------------------------------------------------------------+
    |     domain    |                                                                        |
    |       sld     |   foo://usr:pwd@www.example.co.uk:8042/over/there.htm?name=ferret#nose |
    |       tld     |         \_____/ \_______________/ \__/\_____________/ \_________/ \__/ |
    |   port        |            |           |           |       |               |       /   |
    | relative      |        user_info      host        port    path           query  anchor |
    |   path        |                                                                        |
    |     directory +------------------------------------------------------------------------+
    |     file      |                                                                        |
    |   query       |   foo://usr:pwd@www.example.co.uk:8042/over/there.htm?name=ferret#nose |
    |   anchor      |         \_/ \_/ \_/ \___________/     \____/\_______/                  |
    |               |          |   |   |           |          |       |                      |
    |               |   username pass subdomain    domain  directory file                    |
    |               |                                                                        |
    |               +------------------------------------------------------------------------+
    |               |                                                                        |
    |               |   foo://usr:pwd@www.example.co.uk:8042/over/there.htm?name=ferret#nose |
    |               |                     \_____/ \___/                                      |
    |               |                        |      |                                        |
    |               |                       sld    tld                                       |
    |               |                                                                        |
    +---------------+------------------------------------------------------------------------+

## Description

There are two parsing modes: loose (the default, which is meant 
to be used when working with user input, and is better at reading 
your mind), and strict (which attempts to split URIs according to 
RFC 3986).

To change the parsing mode, just pass either `:loose` or `:strict` 
as the second argument to `UniformResourceIdentifier.parse`.

In loose mode, directories don't need to end with a slash (e.g., 
the "dir" in "/dir?query" is treated as a directory rather than a 
file name), and the URI can start with an authority without being 
preceded by "//" (which means that the "yahoo.com" 
in "yahoo.com/search/" is treated as the host, rather than part 
of the directory path).

## Notes

The regular expressions used to split the URI are directly from [parseUri.js](http://stevenlevithan.com/demo/parseuri/js/)
by [Stephen Levithan](http://stevenlevithan.com/).  
Parsing of the host is done entirely by the [PublicSuffix](http://rubygems.org/gems/public_suffix) 
library by [Simone Carletti](http://www.simonecarletti.com/).  
Parsing of the query string is done entirely by the [Addressable](http://rubygems.org/gems/addressable) 
library by [Bob Aman](https://rubygems.org/profiles/sporkmonger).  
Serialization of the query hash is done entirely by the [ActiveSupport](http://rubygems.org/gems/active_support) 
library by the [Rails](https://github.com/rails/rails) team.  

## Compatibility

`uniform_resource_identifier` was tested in the following Ruby interpreters:

* 1.8.7 - java - 2011-08-23
* 1.8.7 - i686-darwin11.3.0 - 2012-02-08
* 1.9.2 - x86_64-darwin11.2.0 - 2011-07-09
* 1.9.2 - x86_64-darwin11.3.0 - 2012-02-14
* 1.9.3 - x86_64-darwin11.3.0 - 2011-10-30
* 1.9.3 - universal.x86_64-darwin11.3.0 - 2012-02-16
* 1.9.3 - x86_64-darwin11.2.0 - 2011-09-23

## Resources

* [RFC 3986](http://tools.ietf.org/html/rfc3986)

# Contributing to uniform_resource_identifier

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

# Copyright

Copyright (c) 2011 Ryan Scott Lewis. See LICENSE for further details.
