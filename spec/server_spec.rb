require "rspec_helper"
require "json"

class WebHTTPMock
  def self.login
    request = { "login" => { "username" => "user", "password" => "pass" }}
    stub_request( :post, "http://10.0.0.1/nitro/v1/config").
        with(:body => { "object" => request.to_json },
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "sessionid": "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5" }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end

  def self.get_all
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/server").
        with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie' => "sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "server": [{"name": "srv1", "ipaddress": "1.1.1.1", "state": "ENABLED"}, {"name": "srv2", "ipaddress": "2.2.2.2", "state": "DISABLED"}] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.find_by_name(name)
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/server/#{name}").
        with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie' => "sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "server": [{"name": "' + name + '", "ipaddress": "1.1.1.1", "state": "ENABLED"}] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.enable
    request = { "params" => { "action" => "enable" }, "server" => { "name" => "srv3" }}
    stub_request(:post, "http://10.0.0.1/nitro/v1/config").
      with(:body => { "object" => request.to_json},
       :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie'=>'sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5'}).
       to_return({ :status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'}})
  end
  
  def self.disable
    request = { "params" => { "action" => "disable" }, "server" => { "name" => "srv3" }}
    stub_request(:post, "http://10.0.0.1/nitro/v1/config").
      with(:body => { "object" => request.to_json },
       :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie'=>'sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5'}).
       to_return({ :status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'}})
  end
  
  def self.rename
    request = { "params" => { "action" => "rename" }, "server" => { "name" => "newsrvname" }}
    stub_request(:post, "http://10.0.0.1/nitro/v1/config").
      with(:body => { "object" => request.to_json },
       :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie'=>'sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5'}).
       to_return({ :status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'}})
  end

  def self.add(name)
    request = { "server" => { "name" => name, "ipaddress" => "1.1.1.1", "state" => "ENABLED" }}
    stub_request( :post, "http://10.0.0.1/nitro/v1/config").
      with(:body => { "object" => request.to_json },
        :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded'}).
      to_return({ :body => '{"errorcode": 0, "message": "Done"}', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.delete(name)
    stub_request( :delete, "http://10.0.0.1/nitro/v1/config/server/#{name}").
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie' => "sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"}).
      to_return({ :body => '{"errorcode": 0, "message": "Done"}', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.update
    request = { "server" => { "name" => "srv3", "ipaddress" => "10.0.0.3" }}
    stub_request( :put, "http://10.0.0.1/nitro/v1/config").
      with(:body => { "object" => request.to_json },
        :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie'=>'sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5'}).
      to_return(:status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'})
  end
end

describe Netscaler::Server do
  let(:connection) {Netscaler::Connection.new({"username" => "user", "password" => "pass", "hostname" => "10.0.0.1"})}
  before do
    WebHTTPMock.login
    connection.login
  end

  describe "#self.get_all" do
    specify do
      WebHTTPMock.get_all
      Netscaler::Server.get_all(connection).should be_an_instance_of Array
    end
  end

  describe "#self.find_by_name" do
   specify do
     WebHTTPMock.find_by_name "srv1"
     Netscaler::Server.find_by_name(connection, "srv1").should be_an_instance_of Netscaler::Server
   end
  end

 describe "#self.find_by_ip" do
   specify do  
      WebHTTPMock.get_all
      Netscaler::Server.find_by_ip(connection, "1.1.1.1").should be_an_instance_of Netscaler::Server
   end
  end
  
  describe "#self.add" do
    specify do
      name = "srvtest"
      WebHTTPMock.add name
      WebHTTPMock.find_by_name name
      
      options = {"ipaddress" => "1.1.1.1", "state" => "ENABLED"}
      Netscaler::Server.add(connection, name, options).should be_an_instance_of Netscaler::Server
    end
  end
  
  
  describe "#self.delete" do
    specify do
      name = "srvtest"
      
      WebHTTPMock.delete name
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
          WebHTTPMock.disable
          server.disable!.should be_true
        end
      end

      describe "#enabled?" do
        it {server.enabled?.should be_true}
      end
      
      describe "#update" do
        specify do
          WebHTTPMock.update
          server.update!({"ipaddress" => "10.0.0.3"}).should be_true
        end
      end
      
      describe "#rename" do
        specify do
          WebHTTPMock.rename
          server.rename!("newsvrname").should be_true
        end
      end
    end
  
    context "when disabled" do
      let(:server) {Netscaler::Server.new(connection, "srv3", {"ipaddress" => "1.1.1.1", "state" => "DISABLED"})}
       
      describe "#enable!" do
        specify do
          WebHTTPMock.enable
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
