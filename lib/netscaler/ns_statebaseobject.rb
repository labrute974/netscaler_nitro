module Netscaler
  class NSStateBaseObject < NSBaseObject
    def disable!
      if self.enabled?
        payload = {"params" => { "action" => "disable" }, @type => {@nsname_key => @name}}
  
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
        payload = {"params" => { "action" => "enable" }, @type => {@nsname_key => @name}}
    
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
  end
end
