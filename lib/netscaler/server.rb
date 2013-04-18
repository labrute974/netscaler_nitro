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
      
    end
    
    def disable!
      if self.enabled?
        payload = {"params" => "disable", @@type => {"name" => @name}}
  
        if @nitro.post payload
          @state = "DISABLED"
          value = true
        else
          value = false
        end
      else
        value = true
      end
      
      return value
    end
    
    def enable!
      unless self.enabled?
        payload = {"params" => "enable", @@type => {"name" => @name}}
    
        if @nitro.post payload
          @state = "ENABLED"
          value = true
        else
          value = false
        end
      else
        value = true
      end
      
      return value
    end
    
    def enabled?
      if @state == "ENABLED"
        value = true
      else
        value = false
      end
      
      return value
    end
    
    def self.find_by_name(nitro, name)
      response = nitro.get(@@type + '/' + name)

      response = response[@@type] if response
      
      if response
        options = {}
        srv = response[0]
        @@options.each{|opt| options[opt] = srv[opt] if srv.has_key? opt}
        value = Server.new(nitro, name, options)
      else
        value = nil
      end
      
      return value
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
    
    def self.find_by_ip(nitro, ip)
      objects = get_all(nitro)
      object = nil
      
      if objects
        objects.each do |obj|
          if obj.ipaddress == ip
            object = obj
            break
          end
        end
      end
      
      return object
    end
    
    def self.add(nitro, name, options)
      payload = { @@type => { "name" => name } }
      server = Netscaler::Server.new(nitro, name, options)
      
      payload[@@type].merge! options
      
      nitro.post payload
      
      return find_by_name nitro, name
    end
    
    def self.delete(nitro, name)
      nitro.delete @@type + '/' + name
    end
  end
end
