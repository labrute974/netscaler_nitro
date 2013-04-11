module Netscaler
  class Server
    attr_reader :name, :ipaddress, :state
    
    @@type = "server"
    @@options = {
      "name" => "",
      "ipaddress" => "",
      "state" => ""
    }
    
    def initialize(name, ipaddress, state)
      @name = name
      @ipaddress = ipaddress
      @state = state
    end
    
    def ipaddress=
      #code
    end
    
    def disable!
      #code
    end
    
    def enable!
      Server.disable
    end
    
    def self.get(nitro, name = "")
      #code
    end
    
    def self.get_all(nitro)
      response = nitro.get(@@type)
      
      response = response[@@type] if response
      
      if response
        response.map {|srv| }
        #code
      end
      
      return response
    end
    
    def self.find_by_ip(nitro, ip = "")
      #code
    end
    
    def self.find_by_name(nitro, partial_name = "")
      #code
    end
    
    def self.disable(nitro, name = "")
      #code
    end
  end
end
