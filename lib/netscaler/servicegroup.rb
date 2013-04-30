module Netscaler
  class ServiceGroup < NSStateBaseObject
    attr_reader :name, :params
      
    def initialize(nitro, name, options)
      required = ["servicetype"]
      @options = ["servicetype", "maxclient", "cip", "cipHeader", "usip", "downstateflush", "sc", "sp", "srvtimeout", "clttimeout", "useproxyport", "tcpb", "comment", "state", "cmp", "maxreq", "appflowlog" ] 
      @type = "servicegroup"
      @nsname_key = "servicegroupname"

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

    def self.get_options
      ["servicetype", "maxclient", "cip", "cipHeader", "usip", "downstateflush", "sc", "sp", "srvtimeout", "clttimeout", "useproxyport", "tcpb", "comment", "state", "cmp", "maxreq", "appflowlog" ]
    end

    def self.get_type
      "servicegroup"
    end
    
    def self.get_nsname_key
      "servicegroupname"
    end
  end
end