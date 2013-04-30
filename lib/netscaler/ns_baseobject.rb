module Netscaler
  class NSBaseObject
    @params = {}
    @nsname_key = "name"
    
    def rename!(newname)
      raise ArgumentError, "argument should be a String" unless newname.is_a? String
      
      payload = { "params" => { "action" => "rename" }, @type => { @nsname_key => @name, "new#{@nsname_key}" => newname }}
      
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
      
      payload = { @type => {@nsname_key => @name} }
      payload[@type].merge!(params)
      
      if @nitro.put payload
        true
      else
        false
      end
    end

    def self.add(nitro, name, options)
      payload = { get_type => { get_nsname_key => name } }
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
          
          eval(self.name).new(nitro, obj[get_nsname_key], options)
        end
      else
        objects = false
      end
      
      return objects
    end

    def self.delete(nitro, name)
      nitro.delete get_type + '/' + name
    end
    
    def self.get_nsname_key
      "name"
    end
  end
end
