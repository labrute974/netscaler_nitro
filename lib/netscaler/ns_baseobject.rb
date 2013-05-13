module Netscaler
  class NSBaseObject
    @params = {}
    @nsname_key = "name"
    
    def send_action(action, options = {})
      if options.is_a? Array
        options.each do |opt|
          opt.merge!({ @nsname_key => @name })
          raise ArgumentError, "your array (arg:2) must contain hashes" unless opt.is_a? Hash
        end
      else
        raise ArgumentError, "argument must be an Hash or an Array (arg: 2)" unless options.is_a? Hash
        options.merge!({ @nsname_key => @name })
      end
      
      payload = { "params" => { "action" => action}, @type => options }
      
      @nitro.post payload
    end
    
    def rename!(newname)
      raise ArgumentError, "argument should be a String" unless newname.is_a? String
      
      if send_action("rename", { "newname" => newname })
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
          
          options.merge!({"name" => obj[get_nsname_key]})
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
