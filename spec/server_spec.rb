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
  
  def self.find_by_name(name)
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/server/#{name}").
        with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie' => "sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "server": [{"name": "#{name", "ipaddress": "1.1.1.1", "state": "ENABLED"}] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.enable
    stub_request(:post, "http://10.0.0.1/nitro/v1/config").
      with(:body => {"object"=>"{\"params\":\"enable\",\"server\":{\"name\":\"srv3\"}}"},
       :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie'=>'sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5'}).
       to_return({ :status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'}})
  end
  
  def self.disable
    stub_request(:post, "http://10.0.0.1/nitro/v1/config").
      with(:body => {"object"=>"{\"params\":\"disable\",\"server\":{\"name\":\"srv3\"}}"},
       :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie'=>'sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5'}).
       to_return({ :status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'}})
  end
  
  def self.add
    stub_request( :post, "http://10.0.0.1/nitro/v1/config").
      with(:body => {"object"=>"{\"server\":{\"name\":\"srvtest\",\"ipaddress\":\"1.1.1.1\",\"state\":\"ENABLED\"}}"},
           :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded'}).
      to_return({ :body => '{"errorcode": 0, "message": "Done"}', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.delete(name)
    stub_request( :delete, "http://10.0.0.1/nitro/v1/config/server/#{name}").
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie' => "sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"}).
      to_return({ :body => '{"errorcode": 0, "message": "Done"}', :status => 200, :headers => {'Content-Type' => 'application/json' }})
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
      WebHTTPMock.add
      WebHTTPMock.find_by_name name
      options = {"ipaddress" => "1.1.1.1", "state" => "ENABLED"}
      Netscaler::Server.add(connection, name, options).should be_an_instance_of Netscaler::Server
    end
  end
  
  describe "#update" do
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
        it { server.enable!.should be true }
      end
  
      describe "#disable!" do
        specify do
          WebHTTPMock.disable
          server.disable!.should be true
        end
      end

      describe "#enabled?" do
        it {server.enabled?.should be true}
      end
    end
    
    context "when disabled" do
      let(:server) {Netscaler::Server.new(connection, "srv3", {"ipaddress" => "1.1.1.1", "state" => "DISABLED"})}
      describe "#enable!" do
        specify do
          WebHTTPMock.enable
          server.enable!.should be true
        end
      end
  
      describe "#disable!" do
        it { server.disable!.should be true }
      end
      
      describe "#enabled?" do
        it {server.enabled?.should_not be true}
      end
    end
  end
end
