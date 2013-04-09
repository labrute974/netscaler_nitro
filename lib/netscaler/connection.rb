require 'rest-client'
require 'json'

module Netscaler
  class Connection
    attr_reader :hostname, :session_id

    def initialize(options = {})
      raise ArgumentError unless options.is_a? Hash
      raise ArgumentError unless options.count.eql? 3
      %w(username password hostname).each { |k| raise ArgumentError unless options.has_key? k }

      @username = options["username"]
      @password = options["password"]
      @hostname = options["hostname"]

      @base_url = "http://#{@hostname}/nitro/v1"
      @content_type = "application/x-www-form-urlencoded"
      @session_id = nil
    end
    
    def login
      payload = { "login" => { "username" => @username, "password" => @password }}

      response = post payload
      @session_id = JSON.parse(response)["sessionid"]
   end

   def post(payload = {})
      begin
        response = RestClient.post @base_url + "/config", "object=#{payload.to_json}", :content_type => @content_type, :accept => "json"
      rescue => e
        puts e.message
        puts e.backtrace.inspect
        return false
      end

      return response
    end
  end
end
