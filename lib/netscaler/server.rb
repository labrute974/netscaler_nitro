module Netscaler
  class Server < NSStateBaseObject
    attr_reader :name, :params
    
    def initialize(nitro, name, options)
      required = ["ipaddress"]
      @options = ["ipaddress", "state", "comment"] 
      @type = "server"
      @nsname_key = "name"


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
      
      @params["state"] = "ENABLED" unless @params.has_key? "state"
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