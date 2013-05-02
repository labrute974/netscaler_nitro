require "rspec_helper_mock"
require "json"

class WebHTTPMockServiceGroup < WebHTTPMock
  def self.get_nsname_key
    "servicegroupname"
  end
  
  def self.get_type
    "servicegroup"
  end

  def self.unbind(name)
    request = { "params" => { "action" => "unbind" }, get_type => [{ "servername" => "10.112.121.184", "port" => "80", "servicegroupname" => name }]}
    stub_it :post, request
  end
  
  def self.bind(name)
    request = { "params" => { "action" => "bind" }, get_type => [{ "servername" => "10.112.121.184", "port" => "80", "servicegroupname" => name }]}
    stub_it :post, request
  end

  def self.get_all
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/#{get_type}").
        with(:headers => @@headers).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "servicegroup": [ { "servicegroupname": "agentadmin-qa", "numofconnections": 0, "servicetype": "HTTP", "port": 0, "serviceconftype": true, "cachetype": "SERVER", "maxclient": "0", "maxreq": "0", "cacheable": "NO", "cip": "ENABLED", "cipheader": "X-Forwarded-For", "usip": "NO", "useproxyport": "YES", "monweight": "0", "sc": "OFF", "sp": "OFF", "rtspsessionidremap": "OFF", "clttimeout": 180, "svrtimeout": 360, "cka": "NO", "tcpb": "NO", "cmp": "NO", "maxbandwidth": "0", "state": "ENABLED", "svrstate": "DOWN", "delay": 0, "ip": "0.0.0.0", "monthreshold": "0", "monstate": "ENABLED", "weight": "0", "servicegroupid": "0", "monstatcode": 0, "monstatparam1": 0, "monstatparam2": 0, "monstatparam3": 0, "downstateflush": "ENABLED", "statechangetimesec": "Fri Mar  8 11:56:56 2013", "statechangetimemsec": "851", "tickssincelaststatechange": "447285671", "stateupdatereason": "0", "groupcount": "0", "hashid": "0", "graceful": "NO", "appflowlog": "ENABLED" } ] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.find_by_name(name)
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/#{get_type}/#{name}").
        with(:headers => @@headers).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "servicegroup": [ { "servicegroupname": "agentadmin-qa", "numofconnections": 0, "servicetype": "HTTP", "port": 0, "serviceconftype": true, "cachetype": "SERVER", "maxclient": "0", "maxreq": "0", "cacheable": "NO", "cip": "ENABLED", "cipheader": "X-Forwarded-For", "usip": "NO", "useproxyport": "YES", "monweight": "0", "sc": "OFF", "sp": "OFF", "rtspsessionidremap": "OFF", "clttimeout": 180, "svrtimeout": 360, "cka": "NO", "tcpb": "NO", "cmp": "NO", "maxbandwidth": "0", "state": "ENABLED", "svrstate": "DOWN", "delay": 0, "ip": "0.0.0.0", "monthreshold": "0", "monstate": "ENABLED", "weight": "0", "servicegroupid": "0", "monstatcode": 0, "monstatparam1": 0, "monstatparam2": 0, "monstatparam3": 0, "downstateflush": "ENABLED", "statechangetimesec": "Fri Mar  8 11:56:56 2013", "statechangetimemsec": "851", "tickssincelaststatechange": "447285671", "stateupdatereason": "0", "groupcount": "0", "hashid": "0", "graceful": "NO", "appflowlog": "ENABLED" } ] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.add(name)
    request = { get_type => { "servicegroupname" => name, "appflowlog" => "ENABLED", "servicetype" => "HTTP" }}
    stub_it :post, request
  end
  
  def self.update(name)
    request = { "sessionid" => "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5", get_type => { get_nsname_key => name, "appflowlog" => "DISABLED" }}
    stub_request( :put, "http://10.0.0.1/nitro/v1/config").
      with(:body => request.to_json,
        :headers => @@headers).
      to_return(:status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'})
  end

  def self.get_servers(name)
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/servicegroup_servicegroupmember_binding/#{name}").
      with(:headers => @@headers).
      to_return(:status => 200, :body => '{ "errorcode": 0, "message": "Done", "servicegroup_servicegroupmember_binding": [ { "servicegroupname":"' + name + '", "ip": "10.112.121.184", "port": 80, "svrstate": "UP", "weight": "1", "servername": "10.112.121.184", "serverid": "0", "hashid": "0" }, { "servicegroupname":"' + name + '", "ip": "10.112.121.184", "port": 81, "svrstate": "UP", "weight": "1", "servername": "10.112.121.184", "serverid": "0", "hashid": "0" }]}')
  end
  
  def self.enable_server(name)
    request = { "params" => { "action" => "enable" }, get_type => { get_nsname_key => name, "servername" => "srvtest", "port" => "80" }}
    stub_it :post, request
  end
  
  def self.disable_server(name)
    request = { "params" => { "action" => "disable" }, get_type => { get_nsname_key => name, "servername" => "srvtest", "port" => "80" }}
    stub_it :post, request
  end
end

describe Netscaler::ServiceGroup do
  let(:connection) {Netscaler::Connection.new({"username" => "user", "password" => "pass", "hostname" => "10.0.0.1"})}
  let(:sgname) {"sgtest"}
  before do
    WebHTTPMockServiceGroup.login
    connection.login
  end

  describe "#self.get_all" do
    specify do
      WebHTTPMockServiceGroup.get_all
      Netscaler::ServiceGroup.get_all(connection).should be_an_instance_of Array
    end
  end

  describe "#self.find_by_name" do
   specify do
     WebHTTPMockServiceGroup.find_by_name sgname
     Netscaler::ServiceGroup.find_by_name(connection, sgname).should be_an_instance_of Netscaler::ServiceGroup
   end
  end

  describe "#self.add" do
    specify do
      WebHTTPMockServiceGroup.add sgname
      WebHTTPMockServiceGroup.find_by_name sgname
      
      options = {"appflowlog" => "ENABLED", "servicetype" => "HTTP"}
      Netscaler::ServiceGroup.add(connection, sgname, options).should be_an_instance_of Netscaler::ServiceGroup
    end
  end
  
  describe "#self.delete" do
    specify do
      WebHTTPMockServiceGroup.delete sgname
      Netscaler::ServiceGroup.delete(connection, sgname).should be_true
    end
  end
  
  context "when Netscaler::ServiceGroup instanciated" do
    let(:servicegroup) {Netscaler::ServiceGroup.new(connection, sgname, {"appflowlog" => "ENABLED", "servicetype" => "HTTP"})}
    context "when enabled" do
      describe "#enable!" do
        it { servicegroup.enable!.should be_true }
      end
  
      describe "#disable!" do
        specify do
          WebHTTPMockServiceGroup.disable servicegroup.name
          servicegroup.disable!.should be_true
        end
      end

      describe "#enabled?" do
        it {servicegroup.enabled?.should be_true}
      end
      
    end
  
    context "when disabled" do
      before do
        WebHTTPMockServiceGroup.disable servicegroup.name
        servicegroup.disable!
      end
       
      describe "#enable!" do
        specify do
          WebHTTPMockServiceGroup.enable servicegroup.name
          servicegroup.enable!.should be_true
        end
      end
  
      describe "#disable!" do
        it { servicegroup.disable!.should be_true }
      end
      
      describe "#enabled?" do
        it {servicegroup.enabled?.should_not be_true}
      end
    end
    
    describe "#update" do
      specify do
        WebHTTPMockServiceGroup.update servicegroup.name
        servicegroup.update!({"appflowlog" => "DISABLED"}).should be_true
      end
    end
      
    describe "#rename" do
      specify do
        WebHTTPMockServiceGroup.rename servicegroup.name, "newsgname"
        servicegroup.rename!("newsgname").should be_true
      end
    end
    
    describe "#enable_server" do
      specify do
        WebHTTPMockServiceGroup.enable_server servicegroup.name
        servicegroup.enable_server({"servername" => "srvtest", "port" => "80"}).should be_true
      end
    end
    
    describe "#disable_server" do
      specify do
        WebHTTPMockServiceGroup.disable_server servicegroup.name
        servicegroup.disable_server({"servername" => "srvtest", "port" => "80"}).should be_true
      end
    end
    
    describe "#list_servers" do
      specify do
        WebHTTPMockServiceGroup.get_servers servicegroup.name
        servicegroup.list_servers.should be_an_instance_of Array
      end
    end
    
    describe "#bind" do
      specify do
        WebHTTPMockServiceGroup.bind servicegroup.name
        options = [{ "servername" => "10.112.121.184", "port" => "80" }]
        servicegroup.bind(options).should be_true
      end
    end
    
    describe "#unbind" do
      specify do
        WebHTTPMockServiceGroup.unbind servicegroup.name
        options = [{ "servername" => "10.112.121.184", "port" => "80" }]
        servicegroup.unbind(options).should be_true
      end
    end
  end
end
