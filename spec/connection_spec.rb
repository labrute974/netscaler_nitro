require "rspec_helper_mock"

class WebHTTPMock
  def self.login
    stub_request( :post, "http://10.0.0.1/nitro/v1/config").
        with(:body => {"object"=>"{\"login\":{\"username\":\"user\",\"password\":\"pass\"}}"},
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "sessionid": "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5" }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end

  def self.logout
    stub_request( :post, "http://10.0.0.1/nitro/v1/config").
      with(:body => {"object"=>"{\"logout\":{}}"},
        :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie' => 'sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5'}).
      to_return({ :body => '{"errorcode": 0, "message": "Bye!"}', :status => 200, :headers => {'Content-Type' => 'application/json'}})
  end
end

describe Netscaler::Connection do
  before(:all) {
    @connection = Netscaler::Connection.new({"username" => "user", "password" => "pass", "hostname" => "10.0.0.1"})
  }

  describe "#new" do
    it "takes a hash as parameter" do
      @connection.should be_an_instance_of Netscaler::Connection
    end
  end

  context "when logged out" do
    describe "#logged_in?" do
      it { @connection.should_not be_logged_in }
    end

    describe "#logout" do
      it "should be true" do
        @connection.logout
      end
    end
    
    describe "#login" do
      it "should succeed" do
        WebHTTPMock.login
        @connection.login.should be_eql "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"
      end
    end
  end

  context "when logged in" do
    describe "#logged_in?" do 
      it do
        @connection.should be_logged_in
      end
    end

    describe "#login" do
      it "should succeed" do
        @connection.login.should be_eql "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"
      end
    end
    
    describe "#logout" do
      it "should succeed" do
        WebHTTPMock.logout
        @connection.logout
      end
    end
  end
end
