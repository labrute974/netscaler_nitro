module Netscaler
  class LBVserver < NSStateBaseObject
    attr_reader :name, :params

    def initialize(nitro, name, options)
      required = ["servicetype"]
      @options = [ "insertvserveripport", "ipv46", "port", "servicetype", "downstateflush", "disableprimaryondown", "lbmethod", "comment", "state", "appflowlog" ] 
      @type = "lbvserver"
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
    
    def list_bindings
      result = @nitro.get("lbvserver_binding/#{@name}")
      
      if result
        result = result.has_key?("lbvserver_binding") ? result["lbvserver_binding"][0] : []
        
        result.delete @nsname_key
        
        result = Hash[ result.map do |key,val|
            val.each {|val| val.delete @nsname_key }
            
            [ key.sub(/.*_(.*)_.*/,"\\1"), val ]
          end
        ]
      end
      
      return result
    end

    def bind(options)
      raise ArgumentError, "the argument (arg:1) has to be a Hash" unless options.is_a?(Hash)
      params = []
      attrs = { "servicegroup" => { "required" => ["servicegroupname"]}, "policy" => {"required" => ["policyname", "priority"], "attrs" => ["gotoPriorityExpression", "type"]}, "service" => {"required" => ["servicename"], "attrs" => ["weight"] }}
      
      options.each do |k,v|
        raise ArgumentError, "the hash doesn't have the required keys (arg:1) : can have #{attrs.keys.to_s}" unless attrs.has_key?(k)
        raise ArgumentError, "the value of each key should be an Array" unless v.is_a?(Array)
        
        required_attrs = attrs[k]["required"]
        avail_attrs = attrs[k].include?("attrs") ? attrs[k]["attrs"] : []
      
        v.each do |option|
          required_attrs.each {|attr| raise ArgumentError, "the Hash doesn't have the required keys (arg:1) : should have #{required_attrs.to_s}" unless option.include?(attr) }
          option.keys.each {|k| raise ArgumentError, "unknown key (arg:1) : #{k}" unless avail_attrs.include?(k) or required_attrs.include?(k) }
          
          params.concat v
        end
      end
      
      send_action("bind", params)
    end

    def unbind(options)
      raise ArgumentError, "the argument (arg:1) has to be a Hash" unless options.is_a?(Hash)
      params = []
      
      attrs = { "servicegroup" => {"required" => ["servicegroupname"]}, "service" => {"required" => ["servicename"]}, "policy" => {"required" => ["policyname"], "attrs" => ["type"]} }
      
      options.each do |k,v|
        raise ArgumentError, "the hash doesn't have the required keys (arg:1) : can have #{attrs.keys.to_s}" unless attrs.has_key?(k)
        raise ArgumentError, "the value of each key should be an Array" unless v.is_a?(Array)
        
        required_attrs = attrs[k]["required"]
        avail_attrs = attrs[k].include?("attrs") ? attrs[k]["attrs"] : []
      
        v.each do |option|
          required_attrs.each {|attr| raise ArgumentError, "the Hash doesn't have the required keys (arg:1) : should have #{required_attrs.to_s}" unless option.include?(attr) }
          option.keys.each {|k| raise ArgumentError, "unknown key (arg:1) : #{k}" unless avail_attrs.include?(k) or required_attrs.include?(k) }
          
          params.concat v
        end
      end
      
      send_action("unbind", params)
    end

    def self.get_options
      [ "insertvserveripport", "ipv46", "port", "servicetype", "downstateflush", "disableprimaryondown", "lbmethod", "comment", "state", "appflowlog" ]
    end
    
    def self.get_type
      "lbvserver"
    end
    
    def self.get_nsname_key
      "name"
    end
  end
end
