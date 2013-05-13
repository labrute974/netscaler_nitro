require 'rest-client'
require 'json'

module Netscaler
  class Connection
    attr_reader :hostname, :sessionid, :error_message

    def initialize(options = {})
      raise ArgumentError unless options.is_a? Hash
      raise ArgumentError unless options.count.eql? 3
      %w(username password hostname).each { |k| raise ArgumentError unless options.has_key? k }

      @username = options["username"]
      @password = options["password"]
      @hostname = options["hostname"]

      @base_url = "http://#{@hostname}/nitro/v1/config"
      @content_type = "application/x-www-form-urlencoded"
      @sessionid = nil
      @error_message = nil
      @postheaders = { :content_type => @content_type, :cookie => "sessionid=#{@sessionid}", :accept => :json}
    end
    
    def login
      if @sessionid.nil? 
        payload = { "login" => { "username" => @username, "password" => @password }}

        response = post payload
        if response
          @sessionid = response["sessionid"]
          @postheaders[:cookie] = "sessionid=#{@sessionid}"
        end
      end
      
      return @sessionid
    end

    def get(uri)
      begin
        response = RestClient.get @base_url + '/' + uri, @postheaders
      rescue => e
        puts e.message
        puts e.backtrace.inspect
        return false
      end

      resphash = JSON.parse response
      if resphash["errorcode"] != 0
        @error_message = resphash['message']
        retvalue = false
      else
        @error_message = nil
        retvalue = resphash
      end
      return retvalue
    end
    
    def post(payload = {})
      begin
        response = RestClient.post @base_url, "object=#{payload.to_json}", @postheaders
      rescue => e
        puts e.message
        puts e.backtrace.inspect
        return false
      end

      resphash = JSON.parse response
      if resphash["errorcode"] != 0
        @error_message = resphash['message']
        retvalue = false
      else
        @error_message = nil
        retvalue = resphash
      end

      return retvalue
    end
    
    def put(payload)
      begin
        response = RestClient.put @base_url, {"sessionid" => @sessionid}.merge(payload).to_json, @postheaders
      rescue => e
        puts e.message
        puts e.backtrace.inspect
        return false
      end

      resphash = JSON.parse response
      if resphash["errorcode"] != 0
        @error_message = resphash['message']
        retvalue = false
      else
        @error_message = nil
        retvalue = resphash
      end

      return retvalue
    end

    def delete(uri)
      begin
        response = RestClient.delete @base_url + '/' + uri, @postheaders
      rescue
        puts e.message
        puts e.backtrace.inspect
        return false
      end
      
      resphash = JSON.parse response
      if resphash["errorcode"] != 0
        @error_message = resphash['message']
        retvalue = false
      else
        @error_message = nil
        retvalue = resphash
      end
      return retvalue
    end

    def logout
      unless @sessionid.nil?
        payload = { "logout" => {}} 

        response = post payload
        @sessionid = nil if response 
      end

      return @sessionid.nil?
    end

    def logged_in?
      if get ""
        true
      else
        false
      end
    end
  end
end
