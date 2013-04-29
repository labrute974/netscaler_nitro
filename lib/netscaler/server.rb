module Netscaler
  class Server < NSBaseObject
    attr_reader :name, :params
    
    def initialize(nitro, name, options = {})
      required = ["ipaddress"]
      @options = ["ipaddress", "state", "comment"] 
      @type = "server"

      raise ArgumentError, "name should a String" unless name.is_a? String
      raise ArgumentError, "options must be a Hash" unless options.is_a? Hash
      
      options.keys.each { |k| raise ArgumentError, "unknown key (arg:3) : #{k}" unless @options.include? k }
      required.each { |k| raise ArgumentError, "the Hash doesn't have the required keys (arg:3) : should have #{required.to_s}, had => #{options.keys.to_s}" unless options.include? k }
      
      @nitro = nitro
      @name = name
      @params = {}
      options.each do |k,v|
        @params[k] = v
      end
    end
    
    def disable!
      if self.enabled?
        payload = {"params" => { "action" => "disable" }, @type => {"name" => @name}}
  
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
        payload = {"params" => { "action" => "enable" }, @type => {"name" => @name}}
    
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
    
    def self.get_options
      ["ipaddress", "state", "comment"]
    end
    
    def self.get_type
      "server"
    end
  end
end