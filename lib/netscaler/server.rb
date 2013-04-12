module Netscaler
  class Server
    attr_reader :name, :state, :ipaddress
    
    @@type = "server"
    @name = ""
    @@options = ["ipaddress", "state"]
    
    def initialize(nitro, name, options = {})
      @nitro = nitro
      @name = name
      @ipaddress = options["ipaddress"] if options.include? "ipaddress"
      @state = options["state"] if options.include? "state"
    end
    
    def ipaddress=
      #code
    end
    
    def disable!
      #code
    end
    
    def enable!
      Server.disable()
    end
    
    def self.get(nitro, name)
      response = nitro.get(@@type + '/' + name)

      response = response[@@type] if response
      
      if response
        options = {}
        srv = response[0]
        @@options.each{|opt| options[opt] = srv[opt] if srv.has_key? opt}
        Server.new(nitro, name, options)
      end
      
    end
    
    def self.get_all(nitro)
      response = nitro.get(@@type)
      
      response = response[@@type] if response
      
      if response
        objects = response.map do |srv|
          options = {}
          @@options.each{|opt| options[opt] = srv[opt] if srv.has_key? opt}
          
          Server.new(nitro, srv["name"], options)
        end
      else
        objects = false
      end
      
      return objects
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
