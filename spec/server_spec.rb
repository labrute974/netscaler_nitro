require "rspec_helper_mock"
require "json"

class WebHTTPMockServer < WebHTTPMock
  def self.get_type
    "server"
  end

  def self.get_all
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/#{get_type}").
        with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie' => "sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "server": [{"name": "srv1", "ipaddress": "1.1.1.1", "state": "ENABLED"}, {"name": "srv2", "ipaddress": "2.2.2.2", "state": "DISABLED"}] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.find_by_name(name)
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/#{get_type}/#{name}").
        with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie' => "sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "server": [{"name": "' + name + '", "ipaddress": "1.1.1.1", "state": "ENABLED"}] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.add(name)
    request = { get_type => { "name" => name, "ipaddress" => "1.1.1.1", "state" => "ENABLED" }}
    stub_request( :post, "http://10.0.0.1/nitro/v1/config").
      with(:body => { "object" => request.to_json },
        :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded'}).
      to_return({ :body => '{"errorcode": 0, "message": "Done"}', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
end

describe Netscaler::Server do
  let(:connection) {Netscaler::Connection.new({"username" => "user", "password" => "pass", "hostname" => "10.0.0.1"})}
  before do
    WebHTTPMockServer.login
    connection.login
  end

  describe "#self.get_all" do
    specify do
      WebHTTPMockServer.get_all
      Netscaler::Server.get_all(connection).should be_an_instance_of Array
    end
  end

  describe "#self.find_by_name" do
   specify do
     WebHTTPMockServer.find_by_name "srv1"
     Netscaler::Server.find_by_name(connection, "srv1").should be_an_instance_of Netscaler::Server
   end
  end

 describe "#self.find_by_ip" do
   specify do  
      WebHTTPMockServer.get_all
      Netscaler::Server.find_by_ip(connection, "1.1.1.1").should be_an_instance_of Netscaler::Server
   end
  end
  
  describe "#self.add" do
    specify do
      name = "srvtest"
      WebHTTPMockServer.add name
      WebHTTPMockServer.find_by_name name
      
      options = {"ipaddress" => "1.1.1.1", "state" => "ENABLED"}
      Netscaler::Server.add(connection, name, options).should be_an_instance_of Netscaler::Server
    end
  end
  
  describe "#self.delete" do
    specify do
      name = "srvtest"
      
      WebHTTPMockServer.delete name
      Netscaler::Server.delete(connection, name).should be_true
    end
  end
  
  context "when Netscaler::Server instanciated" do
    context "when enabled" do
      let(:server) {Netscaler::Server.new(connection, "srv3", {"ipaddress" => "1.1.1.1", "state" => "ENABLED"})}
      
      describe "#enable!" do
        it { server.enable!.should be_true }
      end
  
      describe "#disable!" do
        specify do
          WebHTTPMockServer.disable
          server.disable!.should be_true
        end
      end

      describe "#enabled?" do
        it {server.enabled?.should be_true}
      end
      
      describe "#update" do
        specify do
          WebHTTPMockServer.update
          server.update!({"ipaddress" => "10.0.0.3"}).should be_true
        end
      end
      
      describe "#rename" do
        specify do
          WebHTTPMockServer.rename
          server.rename!("newsvrname").should be_true
        end
      end
    end
  
    context "when disabled" do
      let(:server) {Netscaler::Server.new(connection, "srv3", {"ipaddress" => "1.1.1.1", "state" => "DISABLED"})}
       
      describe "#enable!" do
        specify do
          WebHTTPMockServer.enable
          server.enable!.should be_true
        end
      end
  
      describe "#disable!" do
        it { server.disable!.should be_true }
      end
      
      describe "#enabled?" do
        it {server.enabled?.should_not be_true}
      end
    end
  end
end
