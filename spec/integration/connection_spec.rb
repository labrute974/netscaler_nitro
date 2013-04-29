require "rspec_helper"

describe Netscaler::Connection do
  before(:all) {
    @connection = Netscaler::Connection.new({"username" => ENV["NETSCALER_USER"], "password" => ENV["NETSCALER_PASS"], "hostname" => ENV["NETSCALER_HOST"]})
  }

  describe "#new" do
    it "takes a hash as parameter" do
      @connection.should be_an_instance_of Netscaler::Connection
    end
  end

  context "when logged out" do
    describe "#logged_in?" do
      it { @connection.should_not be_logged_in }
    end

    describe "#logout" do
      it "should be true" do
        @connection.logout
      end
    end
    
    describe "#login" do
      it "should succeed" do
        @connection.login.should_not be_nil
      end
    end
  end

  context "when logged in" do
    describe "#logged_in?" do 
      it do
        @connection.should be_logged_in
      end
    end

    describe "#login" do
      it "should succeed" do
        @connection.login.should_not be_nil
      end
    end
    
    describe "#logout" do
      it "should succeed" do
        @connection.logout
      end
    end
  end
end
