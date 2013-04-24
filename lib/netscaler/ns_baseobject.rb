module Netscaler
  class NSBaseObject
    @@options = []
    @@type = ""
    @params = {}
    
    def update!(params)
      raise ArgumentError, "argument must be a Hash" unless params.is_a? Hash
      
      params.each do |k,v|
        raise ArgumentError, "unknown key: #{k}" unless @@options.include? k
        @params[k] = v
      end
      
      payload = { @@type => {"name" => @name} }
      payload[@@type].merge!(params)
      
      if @nitro.put payload
        true
      else
        false
      end
    end

    def self.add(nitro, name, options)
      payload = { @@type => { "name" => name } }
      payload[@@type].merge! options
      
      nitro.post payload
      
      return find_by_name nitro, name
    end
    
    def self.find_by_name(nitro, name)
      response = nitro.get(@@type + '/' + name)

      response = response[@@type] if response
      
      if response
        options = {}
        resource = response[0]
        @@options.each {|opt| options[opt] = resource[opt] if resource.has_key? opt}
        
        value = eval(self.name).new(nitro, name, options)
      else
        value = nil
      end
      
      return value
    end
    
    def self.get_all(nitro)
      response = nitro.get(@@type)
      
      response = response[@@type] if response
      
      if response
        objects = response.map do |obj|
          options = {}
          @@options.each{|opt| options[opt] = obj[opt] if obj.has_key? opt}
          
          eval(self.name).new(nitro, obj["name"], options)
        end
      else
        objects = false
      end
      
      return objects
    end

    def self.delete(nitro, name)
      nitro.delete @@type + '/' + name
    end
  end
end
