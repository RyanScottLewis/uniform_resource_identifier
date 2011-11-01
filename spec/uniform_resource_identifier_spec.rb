require 'spec_helper'

# Example URIs:
#   ftp://ftp.is.co.za/rfc/rfc1808.txt
#   http://www.ietf.org/rfc/rfc2396.txt
#   ldap://[2001:db8::7]/c=GB?objectClass?one
#   mailto:John.Doe@example.com
#   news:comp.infosystems.www.servers.unix
#   tel:+1-816-555-1212
#   telnet://192.0.2.16:80/
#   urn:oasis:names:specification:docbook:dtd:xml:4.1.2
#   http://www.foobar.com/test/bar?q=some+thing
#   www.foobar.com/
#   foobar.com/contact_us
#   admin.foobar.com/task/123
#   admin.testpage.com
#   /about
#   index.htm
#   awesome-things.org/thing/42
#   foo-bar.org/mist
#   water.com
#   https://www.water.org/ice
#   http://example.org/absolute/URI/with/absolute/path/to/resource.txt
#   ftp://example.org/resource.txt
#   http://en.wikipedia.org/wiki/URI#Examples_of_URI_references
#   http://example.org/absolute/URI/with/absolute/path/to/resource.txt
#   //example.org/scheme-relative/URI/with/absolute/path/to/resource.txt
#   /relative/URI/with/absolute/path/to/resource.txt
#   relative/path/to/resource.txt
#   ../../../resource.txt
#   ./resource.txt#frag01
#   resource.txt
#   #frag01
#   http://en.wikipedia.org/wiki/Uniform_Resource_Identifier
#   http://the_english_dept.tripod.com/north.html

describe UniformResourceIdentifier do
  subject { UniformResourceIdentifier }
  
  let(:url) do
    "http://usr:pwd@www.test.com:81/dir/dir.2/foo/bar/index.htm?q1=0&&test1&test2=value&arr[]=one&arr[]=two&hsh[foo]=bar&test3=val3#top"  
  end
  
  describe "#parse" do
    it "should correctly parse the given URL" do
      url.should have_uri_specification(
        :protocol  => "http",
        :authority => "usr:pwd@www.test.com:81",
        :user_info => "usr:pwd",
        :username  => "usr",
        :password  => "pwd",
        :host      => "www.test.com",
        :subdomain => "www",
        :domain    => "test.com",
        :sld       => "test",
        :tld       => "com",
        :port      => "81",
        # :relative  => "/dir/dir.2/foo/bar/index.htm?q1=0&test1=true&test2=value&arr[]=one&arr[]=two&hsh[foo]=bar&test3=val3#top",
        :path      => "/dir/dir.2/foo/bar/index.htm",
        :directory => "/dir/dir.2/foo/bar/",
        :file      => "index.htm",
        # :query     => "q1=0&test1=true&test2=value&arr[]=one&arr[]=two&hsh[foo]=bar&test3=val3",
        :anchor    => "top"
      )
      
      url.should have_uri_specification(
        :host => "www.test.com"
      )
    end
  end
  
  describe "#to_s" do
    it "should return the normalized URI" do
      # subject.parse(url).to_s.should == "http://usr:pwd@www.test.com:81/dir/dir.2/foo/bar/index.htm?q1=0&test1=true&test2=value&arr[]=one&arr[]=two&hsh[foo]=bar&test3=val3#top"
      subject.parse(url).to_s.should == "http://usr:pwd@www.test.com:81/dir/dir.2/foo/bar/index.htm?arr%5B%5D=one&arr%5B%5D=two&hsh%5Bfoo%5D=bar&q1=0&test1=true&test2=value&test3=val3#top"
    end
  end
  
  describe "#to_h" do
    it "should return the correct Hash result" do
      subject.parse(url).to_h.should == {
        :protocol =>"http",
        :authority => {
          :user_info => {
            :username => "usr", 
            :password => "pwd"
          },
          :host => {
            :subdomain => "www", 
            :domain => {
              :sld => "test", 
              :tld => "com"
            }
          },
          :port => 81
        }, 
        :relative => {
          :path => { 
            :directory => "/dir/dir.2/foo/bar/", 
            :file => "index.htm"
          }, 
          :query => { # TODO: Should the query_values be strings?
            "q1" => "0", 
            "test1" => true, 
            "test2" => "value", 
            "arr" => ["one", "two"], 
            "hsh" => {
              "foo" => "bar"
            },
            "test3" => "val3"
          }, 
          :anchor=>"top"
        }
      }
    end
  end
  
  describe "The example from the README" do
    it "should be correct, to say the least." do
      url = "foo://usr:pwd@www.example.co.uk:8042/over/there.htm?name=ferret#nose"
      uri = UniformResourceIdentifier.parse(url)
      
      uri.protocol.should == "foo"
      
      uri.authority.to_s.should == "usr:pwd@www.example.co.uk:8042"
      
      uri.authority.user_info.to_s.should == "usr:pwd"
      uri.user_info.to_s.should == "usr:pwd"
      
      uri.authority.user_info.username.should == "usr"
      uri.authority.user_info.password.should == "pwd"
      uri.user_info.username.should == "usr"
      uri.user_info.password.should == "pwd"
      uri.username.should == "usr"
      uri.password.should == "pwd"
      
      uri.authority.host.to_s.should == "www.example.co.uk"
      uri.host.to_s.should == "www.example.co.uk"
      
      uri.authority.host.subdomain.should == "www"
      uri.authority.subdomain.should == "www"
      uri.subdomain.should == "www"
      
      uri.authority.host.domain.to_s.should == "example.co.uk"
      uri.authority.domain.to_s.should == "example.co.uk"
      uri.domain.to_s.should == "example.co.uk"
      
      uri.authority.host.domain.sld.should == "example"
      uri.authority.domain.sld.should == "example"
      uri.domain.sld.should == "example"
      uri.sld.should == "example"
      
      uri.authority.host.domain.tld.should == "co.uk"
      uri.authority.domain.tld.should == "co.uk"
      uri.domain.tld.should == "co.uk"
      uri.tld.should == "co.uk"
      
      uri.authority.port.should == 8042
      uri.port.should == 8042
      
      uri.relative.to_s.should == "/over/there.htm?name=ferret#nose"
      
      uri.relative.path.to_s.should == "/over/there.htm"
      uri.path.to_s.should == "/over/there.htm"
      
      uri.relative.path.directory.to_s.should == "/over/"
      uri.relative.directory.to_s.should == "/over/"
      uri.directory.to_s.should == "/over/"
      
      uri.relative.path.file.to_s.should == "there.htm"
      uri.relative.file.to_s.should == "there.htm"
      uri.file.to_s.should == "there.htm"
      
      uri.relative.query.to_h.should == { "name" => "ferret" }
      uri.relative.query.to_s.should == "name=ferret"
      uri.query.to_h.should == { "name" => "ferret" }
      uri.query.to_s.should == "name=ferret"
      
      uri.relative.anchor.should == "nose"
      uri.anchor.should == "nose"
    end
  end
end