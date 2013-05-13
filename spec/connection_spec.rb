require "rspec_helper_mock"

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
      specify do
        stub_request(:get, "http://10.0.0.1/nitro/v1/config/").
  with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/x-www-form-urlencoded'}).
  to_return(:status => 200, :body => '{ "errorcode": 131, "message": "Session expired."}', :headers => {'Content-Type' => 'application/json' })
        @connection.should_not be_logged_in
      end
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
      specify do
        stub_request(:get, "http://10.0.0.1/nitro/v1/config/").
  with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/x-www-form-urlencoded'}).
  to_return(:status => 200, :body => '{ "errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json' })
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
