require "rspec_helper_mock"
require "json"

class WebHTTPMockServer < WebHTTPMock
  def self.get_nsname_key
    "name"
  end
  
  def self.get_type
    "server"
  end

  def self.get_all
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/#{get_type}").
        with(:headers => @@headers).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "server": [{"name": "srv1", "ipaddress": "1.1.1.1", "state": "ENABLED"}, {"name": "srv2", "ipaddress": "2.2.2.2", "state": "DISABLED"}] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.update(name)
    request = { "sessionid" => "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5", get_type => { get_nsname_key => name, "ipaddress" => "10.0.0.3" }}
    
    stub_request( :put, "http://10.0.0.1/nitro/v1/config").
      with(:body => request.to_json,
        :headers => @@headers).
      to_return(:status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'})
  end

  def self.find_by_name(name)
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/#{get_type}/#{name}").
        with(:headers => @@headers).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "server": [{"name": "' + name + '", "ipaddress": "1.1.1.1", "state": "ENABLED"}] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.add(name)
    request = { get_type => { "name" => name, "ipaddress" => "1.1.1.1", "state" => "ENABLED" }}
    stub_it :post, request
  end
end

describe Netscaler::Server do
  let(:connection) {Netscaler::Connection.new({"username" => "user", "password" => "pass", "hostname" => "10.0.0.1"})}
  let(:servername) {"srvtest"}
  
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
     WebHTTPMockServer.find_by_name servername
     Netscaler::Server.find_by_name(connection, servername).should be_an_instance_of Netscaler::Server
   end
  end

 describe "#self.find_by_ip" do
   specify do  
      WebHTTPMockServer.get_all
      Netscaler::Server.find_by_ip(connection, "1.1.1.1").should be_an_instance_of Hash
   end
  end
  
  describe "#self.add" do
    specify do
      WebHTTPMockServer.add servername
      WebHTTPMockServer.find_by_name servername
      
      options = {"ipaddress" => "1.1.1.1", "state" => "ENABLED"}
      Netscaler::Server.add(connection, servername, options).should be_an_instance_of Netscaler::Server
    end
  end
  
  describe "#self.delete" do
    specify do
      WebHTTPMockServer.delete servername
      Netscaler::Server.delete(connection, servername).should be_true
    end
  end
  
  context "when Netscaler::Server instanciated" do
    context "when enabled" do
      let(:server) {Netscaler::Server.new(connection, servername, {"ipaddress" => "1.1.1.1", "state" => "ENABLED"})}
      
      describe "#enable!" do
        it { server.enable!.should be_true }
      end
  
      describe "#disable!" do
        specify do
          WebHTTPMockServer.disable servername
          server.disable!.should be_true
        end
      end

      describe "#enabled?" do
        it {server.enabled?.should be_true}
      end
      
      describe "#update" do
        specify do
          WebHTTPMockServer.update(servername)
          server.update!({"ipaddress" => "10.0.0.3"}).should be_true
        end
      end
      
      describe "#rename" do
        specify do
          newname = "newsvrname"
          WebHTTPMockServer.rename servername, newname
          server.rename!(newname).should be_true
        end
      end
    end
  
    context "when disabled" do
      let(:server) {Netscaler::Server.new(connection, servername, {"ipaddress" => "1.1.1.1", "state" => "DISABLED"})}
       
      describe "#enable!" do
        specify do
          WebHTTPMockServer.enable servername
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
