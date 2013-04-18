module Netscaler
  class Server < NSBaseObject
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
  end
end
