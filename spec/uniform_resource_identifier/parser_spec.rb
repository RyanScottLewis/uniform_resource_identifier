require 'spec_helper'

describe UniformResourceIdentifier::Parser do
  subject { UniformResourceIdentifier::Parser }
  
  describe "#parse" do
    it "should return a Hash containing the correct results" do
      url = "http://usr:pwd@www.test.com:81/dir/dir.2/foo/bar/index.htm?q1=0&&test1&test2=value&arr[]=one&arr[]=two&hsh[foo]=bar&test3=val3#top"
      
      result_hash = {
        :protocol  => "http",
        :authority => "usr:pwd@www.test.com:81",
        :user_info => "usr:pwd",
        :username  => "usr",
        :password  => "pwd",
        :host      => "www.test.com",
        :port      => "81",
        :relative  => "/dir/dir.2/foo/bar/index.htm?q1=0&&test1&test2=value&arr[]=one&arr[]=two&hsh[foo]=bar&test3=val3#top",
        :path      => "/dir/dir.2/foo/bar/index.htm",
        :directory => "/dir/dir.2/foo/bar/",
        :file      => "index.htm",
        :query     => "q1=0&&test1&test2=value&arr[]=one&arr[]=two&hsh[foo]=bar&test3=val3",
        :anchor    => "top"
      }
      
      subject.parse(url, :loose).should == result_hash
      subject.parse(url, :strict).should == result_hash
    end
  end
end
