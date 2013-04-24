module Netscaler
  class Server < NSBaseObject
    attr_reader :name, :params
    
    @@options = ["ipaddress", "state"]
    @@type = "server"
    @name = ""
    @params = {}
    
    def initialize(nitro, name, options = {})
      raise ArgumentError, "name should a String" unless name.is_a? String
      raise ArgumentError, "options must be a Hash" unless options.is_a? Hash
      raise ArgumentError, "the Hash doesn't have the right keys: should have #{@@options.to_s}, had => #{options.keys.to_s}" if @@options != options.keys
      
      @nitro = nitro
      @name = name
      @params = {}
      @@options.each do |k|
        @params[k] = options[k]
      end
    end
    
    def ipaddress=
      
    end
    
    def disable!
      if self.enabled?
        payload = {"params" => { "action" => "disable" }, @@type => {"name" => @name}}
  
        if @nitro.post payload
          @params["state"] = "DISABLED"
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
        payload = {"params" => { "action" => "enable" }, @@type => {"name" => @name}}
    
        if @nitro.post payload
          @params["state"] = "ENABLED"
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
      if @params["state"] == "ENABLED"
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
          if obj.params["ipaddress"] == ip
            object = obj
            break
          end
        end
      end
      
      return object
    end
  end
end