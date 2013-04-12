require "rspec_helper"

class WebHTTPMock
  def self.login
    stub_request( :post, "http://10.0.0.1/nitro/v1/config").
        with(:body => {"object"=>"{\"login\":{\"username\":\"user\",\"password\":\"pass\"}}"},
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "sessionid": "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5" }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end

  def self.get_all
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/server").
        with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie' => "sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "server": [{"name": "srv1", "ipaddress": "1.1.1.1", "state": "ENABLED"}, {"name": "srv2", "ipaddress": "2.2.2.2", "state": "DISABLED"}] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
end

describe Netscaler::Server do
  before(:all) do
    WebHTTPMock.login
    @connection = Netscaler::Connection.new({"username" => "user", "password" => "pass", "hostname" => "10.0.0.1"})
    @connection.login
  end
  
  describe "#update" do
  end
  
  describe "#self.get_all" do
    it "should return an array" do
      WebHTTPMock.get_all
      Netscaler::Server.get_all(@connection).should be_an_instance_of Array
    end
  end

  describe "#self.get" do
    context "when server exists" do
    end
    
    context "when server does not exist" do
    end
  end
  
  describe "#self.find_by_name" do
  end
  
  describe "#self.find_by_ip" do
  end
  
  describe "#self.add" do
  end
  
  describe "#self.delete" do
  end
end
