require "rspec_helper"

describe Netscaler::ServiceGroup do
  let(:connection) {Netscaler::Connection.new({"username" => ENV["NETSCALER_USER"], "password" => ENV["NETSCALER_PASS"], "hostname" => ENV["NETSCALER_HOST"]})}
  let(:sg_name) { "rspec_sgtest" }
  let(:new_sg_name) { "rspec_sgtest_renamed" }
  let(:new_type) { "TCP" }
  let(:params) { {"servicetype" => "HTTP", "comment" => "Rspec Test ServiceGroup, will get deleted"} }
  
  before do
    connection.login
  end

  describe "#self.add" do
    specify { Netscaler::ServiceGroup.add(connection, sg_name, params).should be_an_instance_of Netscaler::ServiceGroup }
  end
  
  context "when Netscaler::ServiceGroup instanciated" do
    let(:servicegroup) { Netscaler::ServiceGroup.find_by_name(connection, sg_name) }
    
    describe "#enable!" do
      specify { servicegroup.enable!.should be_true }
    end
    
    describe "#enabled?" do
      specify { servicegroup.enabled?.should be_true }
    end
  
    describe "#disable!" do
      specify { servicegroup.disable!.should be_true }
    end
    
    describe "#enabled?" do
      specify { servicegroup.enabled?.should_not be_true }
    end
    
    describe "#update!" do
      specify { servicegroup.update!({ "cip" => "ENABLED", "cipheader" => "X-Forwarded-For" }).should be_true }
    end
    
    
    context "when binding servers to ServiceGroup" do
      let(:servicegroup) { Netscaler::ServiceGroup.find_by_name(connection, sg_name) }
      let(:srv1) { "rspec_server_1" }
      let(:srv2) { "rspec_server_2" }
      
      describe "#list_servers" do
        specify { servicegroup.list_servers.count.should be 0 }
      end
      
      describe "#bind" do
        it "should create two servers and bind them" do
          Netscaler::Server.add(connection, srv1, { "ipaddress" => "1.1.1.1", "comment" => "Rspec Test binding servers to ServiceGroup" })
          Netscaler::Server.add(connection, srv2, { "ipaddress" => "1.1.1.2", "comment" => "Rspec Test binding servers to ServiceGroup" })
          
          servicegroup.bind([{ "servername" => srv1, "port" => "80" }, { "servername" => srv2, "port" => "80" }]).should be_true
        end
      end

      describe "#list_servers" do
        specify { servicegroup.list_servers.count.should be 2 } 
      end

      describe "#disable_server" do
        specify do
          servicegroup.disable_server({ "servername" => srv1, "port" => "80" }).should be_true
        end  
      end

      describe "#disable_server" do
        specify do
          servicegroup.enable_server({ "servername" => srv1, "port" => "80" }).should be_true
        end
      end

      describe "#unbind" do
        it "should unbind the servers and delete them" do
          servicegroup.unbind([{ "servername" => srv1, "port" => "80" }, { "servername" => srv2, "port" => "80" }]).should be_true
          
          Netscaler::Server.delete(connection, srv1)
          Netscaler::Server.delete(connection, srv2)
        end
      end

      describe "#list_servers" do
        specify { servicegroup.list_servers.count.should be_eql 0 }
      end
    end
    
    describe "#rename!" do
      specify { servicegroup.rename!(new_sg_name).should be_true }
    end
  end
  
  describe "#self.get_all" do
    specify { Netscaler::ServiceGroup.get_all(connection).should be_an_instance_of Array }
  end

  describe "#self.delete" do
    specify { Netscaler::ServiceGroup.delete(connection, new_sg_name).should be_true }
  end
end