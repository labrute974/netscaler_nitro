require "rspec_helper"

describe Netscaler::LBVserver do
  let(:connection) {Netscaler::Connection.new({"username" => ENV["NETSCALER_USER"], "password" => ENV["NETSCALER_PASS"], "hostname" => ENV["NETSCALER_HOST"]})}
  let(:lbvserver_name) { "rspec_lbvservertest" }
  let(:new_lbvserver_name) { "rspec_lbvservertest_renamed" }
  let(:new_type) { "HTTP" }
  let(:params) { {"servicetype" => "HTTP", "ipv46" => "1.1.1.1", "port" => "80", "comment" => "Rspec Test LBVserver, will get deleted"} }
  
  before do
    connection.login
  end

  describe ".add" do
    specify { Netscaler::LBVserver.add(connection, lbvserver_name, params).should be_an_instance_of Netscaler::LBVserver }
  end
  
  context "when Netscaler::LBVserver instanciated" do
    let(:lbvserver) { Netscaler::LBVserver.find_by_name(connection, lbvserver_name) }
    
    describe "#enable!" do
      specify { lbvserver.enable!.should be_true }
    end
    
    describe "#enabled?" do
      specify { lbvserver.enabled?.should be_true }
    end
  
    describe "#disable!" do
      specify { lbvserver.disable!.should be_true }
    end
    
    describe "#enabled?" do
      specify { lbvserver.enabled?.should_not be_true }
    end
    
    describe "#update!" do
      specify { lbvserver.update!({ "ipv46" => "10.10.10.10"}).should be_true }
    end
    
    
    context "when binding servers to LBVserver" do
      let(:lbvserver) { Netscaler::LBVserver.find_by_name(connection, lbvserver_name) }
      let(:sg1) { "rspec_sg_1" }
      let(:sg2) { "rspec_sg_2" }
      
      describe "#list_bindings" do
        subject { lbvserver.list_bindings }
        it { should_not include "servicegroup" }
        
        it "should return a count of zero" do
          subject.count.should be 0
        end
      end
      
      describe "#bind" do
        it "should create two servers and bind them" do
          Netscaler::ServiceGroup.add(connection, sg1, {"servicetype" => "HTTP", "comment" => "Rspec Test ServiceGroup, will get deleted"})
          Netscaler::ServiceGroup.add(connection, sg2, {"servicetype" => "HTTP", "comment" => "Rspec Test ServiceGroup, will get deleted"})
          
          lbvserver.bind({"servicegroup" => [{ "servicegroupname" => sg1 }, { "servicegroupname" => sg2 }]}).should be_true
        end
      end

      describe "#list_bindings" do
        subject { lbvserver.list_bindings }
        it { should include "servicegroup" }
        
        it "should return 2 servicegroups" do
          subject["servicegroup"].count.should be 2
        end
      end

      describe "#unbind" do
        it "should unbind the servers and delete them" do
          lbvserver.unbind({"servicegroup" => [{ "servicegroupname" => sg1 }, { "servicegroupname" => sg2 }]}).should be_true
          
          Netscaler::ServiceGroup.delete(connection, sg1)
          Netscaler::ServiceGroup.delete(connection, sg2)
        end
      end

      describe "#list_bindings" do
        subject { lbvserver.list_bindings }
        it { should_not include "servicegroup" }
        
        it "should return a count of zero" do
          subject.count.should be 0
        end
      end
    end
    
    describe "#rename!" do
      specify { lbvserver.rename!(new_lbvserver_name).should be_true }
    end
  end
  
  describe ".get_all" do
    specify { Netscaler::LBVserver.get_all(connection).should be_an_instance_of Array }
  end

  describe ".delete" do
    specify { Netscaler::LBVserver.delete(connection, new_lbvserver_name).should be_true }
  end
end