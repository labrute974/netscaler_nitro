require "rspec_helper_mock"
require "json"

class WebHTTPMockLBVserver < WebHTTPMock
  def self.get_nsname_key
    "name"
  end
  
  def self.get_type
    "lbvserver"
  end 

  def self.unbind(name)
    request = { "params" => { "action" => "unbind" }, get_type => [{ "servicegroupname" => "sgtest", "name" => name }]}
    stub_it :post, request
  end
  
  def self.bind(name)
    request = { "params" => { "action" => "bind" }, get_type => [{ "servicegroupname" => "sgtest", "name" => name }, { "policyname" => "test", "priority" => "10", "name" => "lbvservertest" } ] }
    stub_it :post, request
  end

  def self.get_all
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/#{get_type}").
        with(:headers => @@headers).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "lbvserver":[ { "name": "vservertest", "insertvserveripport": "OFF", "ipv46": "1.1.1.1", "ippattern": "0.0.0.0", "ipmask": "255.255.255.255", "ipmapping": "0.0.0.0", "port": 3306, "range": "1", "servicetype": "MYSQL", "type": "ADDRESS", "curstate": "DOWN", "effectivestate": "DOWN", "status": 1, "lbrrreason": 0, "cachetype": "SERVER", "authentication": "OFF", "authn401": "OFF", "weight": "0", "dynamicweight": "0", "priority": "0", "clttimeout": "180", "somethod": "NONE", "sopersistence": "DISABLED", "sopersistencetimeout": "2", "sothreshold": "0", "lbmethod": "LEASTCONNECTION", "hashlength": "0", "dataoffset": "0", "health": "0", "datalength": "0", "netmask": "0.0.0.0", "v6netmasklen": "0", "ruletype": "0", "m": "IP", "tosid": "0", "persistencetype": "NONE", "timeout": 2, "persistmask": "255.255.255.255", "v6persistmasklen": "128", "persistencebackup": "NONE", "backuppersistencetimeout": 2, "cacheable": "NO", "pq": "OFF", "sc": "OFF", "rtspnat": "OFF", "sessionless": "DISABLED", "map": "OFF", "connfailover": "DISABLED", "redirectportrewrite": "DISABLED", "downstateflush": "ENABLED", "disableprimaryondown": "DISABLED", "gt2gb": "DISABLED", "thresholdvalue": 0, "invoke": false, "version": 0, "totalservices": "1", "activeservices": "0", "statechangetimeseconds": "1362799899", "statechangetimemsec": "125", "tickssincelaststatechange": "475338116", "hits": "0", "push": "DISABLED", "pushlabel": "none", "pushmulticlients": "NO", "l2conn": "OFF", "mysqlprotocolversion": "10", "mysqlserverversion": "5.0.77-ns", "mysqlcharacterset": "8", "mysqlservercapabilities": "41613", "appflowlog": "ENABLED" }, { "name": "vservertest2", "insertvserveripport": "OFF", "ipv46": "1.1.1.2", "ippattern": "0.0.0.0", "ipmask": "255.255.255.255", "ipmapping": "0.0.0.0", "port": 3306, "range": "1", "servicetype": "TCP", "type": "ADDRESS", "curstate": "DOWN", "effectivestate": "DOWN", "status": 1, "lbrrreason": 0, "cachetype": "SERVER", "authentication": "OFF", "authn401": "OFF", "weight": "0", "dynamicweight": "0", "priority": "0", "clttimeout": "9000", "somethod": "NONE", "sopersistence": "DISABLED", "sopersistencetimeout": "2", "sothreshold": "0", "lbmethod": "LEASTCONNECTION", "hashlength": "0", "dataoffset": "0", "health": "0", "datalength": "0", "netmask": "0.0.0.0", "v6netmasklen": "0", "ruletype": "0", "m": "IP", "tosid": "0", "persistencetype": "NONE", "timeout": 2, "persistmask": "255.255.255.255", "v6persistmasklen": "128", "persistencebackup": "NONE", "backuppersistencetimeout": 2, "cacheable": "NO", "pq": "OFF", "sc": "OFF", "rtspnat": "OFF", "sessionless": "DISABLED", "map": "OFF", "connfailover": "DISABLED", "redirectportrewrite": "DISABLED", "downstateflush": "ENABLED", "disableprimaryondown": "DISABLED", "gt2gb": "DISABLED", "thresholdvalue": 0, "invoke": false, "version": 0, "totalservices": "1", "activeservices": "0", "statechangetimeseconds": "1362799899", "statechangetimemsec": "130", "tickssincelaststatechange": "475338116", "hits": "0", "push": "DISABLED", "pushlabel": "none", "pushmulticlients": "NO", "l2conn": "OFF", "mysqlprotocolversion": "10", "mysqlserverversion": "5.0.77-ns", "mysqlcharacterset": "8", "mysqlservercapabilities": "41613", "appflowlog": "ENABLED" } ] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.find_by_name(name)
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/#{get_type}/#{name}").
        with(:headers => @@headers).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "lbvserver": [ { "name": "vservertest", "insertvserveripport": "OFF", "ipv46": "1.1.1.1", "ippattern": "0.0.0.0", "ipmask": "255.255.255.255", "ipmapping": "0.0.0.0", "port": 3306, "range": "1", "servicetype": "MYSQL", "type": "ADDRESS", "curstate": "DOWN", "effectivestate": "DOWN", "status": 1, "lbrrreason": 0, "cachetype": "SERVER", "authentication": "OFF", "authn401": "OFF", "weight": "0", "dynamicweight": "0", "priority": "0", "clttimeout": "180", "somethod": "NONE", "sopersistence": "DISABLED", "sopersistencetimeout": "2", "sothreshold": "0", "lbmethod": "LEASTCONNECTION", "hashlength": "0", "dataoffset": "0", "health": "0", "datalength": "0", "netmask": "0.0.0.0", "v6netmasklen": "0", "ruletype": "0", "m": "IP", "tosid": "0", "persistencetype": "NONE", "timeout": 2, "persistmask": "255.255.255.255", "v6persistmasklen": "128", "persistencebackup": "NONE", "backuppersistencetimeout": 2, "cacheable": "NO", "pq": "OFF", "sc": "OFF", "rtspnat": "OFF", "sessionless": "DISABLED", "map": "OFF", "connfailover": "DISABLED", "redirectportrewrite": "DISABLED", "downstateflush": "ENABLED", "disableprimaryondown": "DISABLED", "gt2gb": "DISABLED", "thresholdvalue": 0, "invoke": false, "version": 0, "totalservices": "1", "activeservices": "0", "statechangetimeseconds": "1362799899", "statechangetimemsec": "125", "tickssincelaststatechange": "475338116", "hits": "0", "push": "DISABLED", "pushlabel": "none", "pushmulticlients": "NO", "l2conn": "OFF", "mysqlprotocolversion": "10", "mysqlserverversion": "5.0.77-ns", "mysqlcharacterset": "8", "mysqlservercapabilities": "41613", "appflowlog": "ENABLED" } ] }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.add(name)
    request = { get_type => { "name" => name, "appflowlog" => "ENABLED", "servicetype" => "HTTP" }}
    stub_it :post, request
  end
  
  def self.update(name)
    request = { "sessionid" => "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5", get_type => { get_nsname_key => name, "appflowlog" => "DISABLED" }}
    stub_request( :put, "http://10.0.0.1/nitro/v1/config").
      with(:body => request.to_json,
        :headers => @@headers).
      to_return(:status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'})
  end

  def self.list_bindings(name)
    stub_request( :get, "http://10.0.0.1/nitro/v1/config/lbvserver_binding/#{name}").
      with(:headers => @@headers).
      to_return(:status => 200, :body => '{ "errorcode": 0, "message": "Done", "lbvserver_binding": [ { "name": "' + name + '", "lbvserver_servicegroup_binding": [ { "name": "vservertest", "servicegroupname": "sgtest", "stateflag": "33554432" } ], "lbvserver_rewritepolicy_binding": [ { "name": "vservertest", "policyname": "policy-test", "stateflag": "8", "priority": "100", "gotopriorityexpression": "END", "bindpoint": "REQUEST", "invoke": false, "labeltype": "", "labelname": "" } ] } ] }')
  end
end

describe Netscaler::LBVserver do
  let(:connection) {Netscaler::Connection.new({"username" => "user", "password" => "pass", "hostname" => "10.0.0.1"})}
  let(:lbvsvrname) {"lbvservertest"}
  before do
    WebHTTPMockLBVserver.login
    connection.login
  end

  describe "#self.get_all" do
    specify do
      WebHTTPMockLBVserver.get_all
      Netscaler::LBVserver.get_all(connection).should be_an_instance_of Array
    end
  end

  describe "#self.find_by_name" do
   specify do
     WebHTTPMockLBVserver.find_by_name lbvsvrname
     Netscaler::LBVserver.find_by_name(connection, lbvsvrname).should be_an_instance_of Netscaler::LBVserver
   end
  end

  describe "#self.add" do
    specify do
      WebHTTPMockLBVserver.add lbvsvrname
      WebHTTPMockLBVserver.find_by_name lbvsvrname
      
      options = {"appflowlog" => "ENABLED", "servicetype" => "HTTP"}
      Netscaler::LBVserver.add(connection, lbvsvrname, options).should be_an_instance_of Netscaler::LBVserver
    end
  end
  
  describe "#self.delete" do
    specify do
      WebHTTPMockLBVserver.delete lbvsvrname
      Netscaler::LBVserver.delete(connection, lbvsvrname).should be_true
    end
  end
  
  context "when Netscaler::LBVserver instanciated" do
    let(:lbvserver) {Netscaler::LBVserver.new(connection, lbvsvrname, {"appflowlog" => "ENABLED", "servicetype" => "HTTP"})}
    context "when enabled" do
      describe "#enable!" do
        it { lbvserver.enable!.should be_true }
      end
  
      describe "#disable!" do
        specify do
          WebHTTPMockLBVserver.disable lbvserver.name
          lbvserver.disable!.should be_true
        end
      end

      describe "#enabled?" do
        it {lbvserver.enabled?.should be_true}
      end
      
    end
  
    context "when disabled" do
      before do
        WebHTTPMockLBVserver.disable lbvserver.name
        lbvserver.disable!
      end
       
      describe "#enable!" do
        specify do
          WebHTTPMockLBVserver.enable lbvserver.name
          lbvserver.enable!.should be_true
        end
      end
  
      describe "#disable!" do
        it { lbvserver.disable!.should be_true }
      end
      
      describe "#enabled?" do
        it {lbvserver.enabled?.should_not be_true}
      end
    end
    
    describe "#update" do
      specify do
        WebHTTPMockLBVserver.update lbvserver.name
        lbvserver.update!({"appflowlog" => "DISABLED"}).should be_true
      end
    end
      
    describe "#rename" do
      specify do
        WebHTTPMockLBVserver.rename lbvserver.name, "newlbvsvrname"
        lbvserver.rename!("newlbvsvrname").should be_true
      end
    end
    
    describe "#list_bindings" do
      specify do
        WebHTTPMockLBVserver.list_bindings lbvserver.name
        lbvserver.list_bindings.should be_an_instance_of Hash
      end
    end
    
    describe "#bind" do
      specify do
        WebHTTPMockLBVserver.bind lbvserver.name
        options = { "servicegroup" => [{ "servicegroupname" => "sgtest" }], "policy" => [{"policyname" => "test", "priority" => "10" }]}
        lbvserver.bind(options).should be_true
      end
    end
    
    describe "#unbind" do
      specify do
        WebHTTPMockLBVserver.unbind lbvserver.name
        options = { "servicegroup" => [{ "servicegroupname" => "sgtest" }]}
        lbvserver.unbind(options).should be_true
      end
    end
  end
end
