module Netscaler
  class NSBaseObject
    @@options = []
    @@type = ""
    
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
        srv = response[0]
        @@options.each{|opt| options[opt] = srv[opt] if srv.has_key? opt}
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
