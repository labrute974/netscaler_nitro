module Netscaler
  class NSBaseObject
    @params = {}
    
    def rename!(newname)
      raise ArgumentError, "argument should be a String" unless newname.is_a? String
      
      payload = { "params" => { "action" => "rename" }, @type => { "name" => @name, "newname" => newname }}
      
      if @nitro.post payload
        @name = newname
        true
      else
        false
      end
    end

    def update!(params)
      raise ArgumentError, "argument must be a Hash" unless params.is_a? Hash
      
      params.each do |k,v|
        raise ArgumentError, "unknown key: #{k}" unless @options.include? k
        @params[k] = v
      end
      
      payload = { @type => {"name" => @name} }
      payload[@type].merge!(params)
      
      if @nitro.put payload
        true
      else
        false
      end
    end

    def self.add(nitro, name, options)
      payload = { get_type => { "name" => name } }
      payload[get_type].merge! options
      
      response = nitro.post payload
      
      if response
        find_by_name nitro, name
      else
        false
      end
    end
    
    def self.find_by_name(nitro, name)
      response = nitro.get(get_type + '/' + name)

      response = response[get_type] if response
      
      if response
        options = {}
        resource = response[0]
        self.get_options.each {|opt| options[opt] = resource[opt] if resource.has_key? opt}
        
        value = eval(self.name).new(nitro, name, options)
      else
        value = nil
      end
      
      return value
    end
    
    def self.get_all(nitro)
      response = nitro.get(get_type)
      
      response = response[get_type] if response
      
      if response
        objects = response.map do |obj|
          options = {}
          self.get_options.each do |opt|
            options[opt] = obj[opt] if obj.has_key? opt
          end
          
          eval(self.name).new(nitro, obj["name"], options)
        end
      else
        objects = false
      end
      
      return objects
    end

    def self.delete(nitro, name)
      nitro.delete get_type + '/' + name
    end
  end
end
