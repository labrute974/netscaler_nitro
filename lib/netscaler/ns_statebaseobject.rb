module Netscaler
  class NSStateBaseObject < NSBaseObject
    def disable!
      if self.enabled?
        value = send_action "disable"
        @params["state"] = "DISABLED" if value
      else
        value = true
      end
      
      return value
    end
    
    def enable!
      unless self.enabled?
        value = send_action "enable"
        @params["state"] = "ENABLED" if value
      else
        value = true
      end
      
      return value
    end
    
    def enabled?
      value = @params["state"] == "ENABLED" ? true : false
      
      return value
    end
  end
end
