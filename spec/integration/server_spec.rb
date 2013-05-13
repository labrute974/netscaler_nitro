require "rspec_helper"

describe Netscaler::Server do
  let(:connection) {Netscaler::Connection.new({"username" => ENV["NETSCALER_USER"], "password" => ENV["NETSCALER_PASS"], "hostname" => ENV["NETSCALER_HOST"]})}
  let(:server_name) { "rspec_server_test" }
  let(:new_server_name) { "rspec_server_test_renamed" }
  let(:new_ip) { "2.2.2.2" }
  let(:params) { {"ipaddress" => "1.1.1.1", "comment" => "Rspec Test server, will get deleted"} }
  
  before do
    connection.login
  end

  describe "#self.add" do
    specify { Netscaler::Server.add(connection, server_name, params).should be_an_instance_of Netscaler::Server }
  end
  
  context "before doing update / rename operation" do
    describe "#self.find_by_ip" do
      specify { Netscaler::Server.find_by_ip(connection, params["ipaddress"]).should be_an_instance_of Hash }
    end
  end
  
  context "when Netscaler::Server instanciated" do
    let(:server) { Netscaler::Server.find_by_name(connection, server_name) }
    
    describe "#enable!" do
      specify { server.enable!.should be_true }
    end
    
    describe "#enabled?" do
      specify { server.enabled?.should be_true }
    end
  
    describe "#disable!" do
      specify { server.disable!.should be_true }
    end
    
    describe "#enabled?" do
      specify { server.enabled?.should_not be_true }
    end
    
    describe "#update!" do
      specify { server.update!({"ipaddress" => new_ip}).should be_true }
    end
    
    describe "#rename!" do
      specify { server.rename!(new_server_name).should be_true }
    end
  end
  
  context "after doing update / rename operation" do
    describe "#self.find_by_ip" do
      specify { Netscaler::Server.find_by_ip(connection, new_ip)["name"].should be_eql new_server_name }
    end
  end
  
  describe "#self.get_all" do
    specify { Netscaler::Server.get_all(connection).should be_an_instance_of Array }
  end

  describe "#self.delete" do
    specify { Netscaler::Server.delete(connection, new_server_name).should be_true }
  end
end
