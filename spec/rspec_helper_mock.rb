$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'netscaler'
require "webmock/rspec"

include WebMock::API

class WebHTTPMock
  def self.login
    request = { "login" => { "username" => "user", "password" => "pass" }}
    stub_request( :post, "http://10.0.0.1/nitro/v1/config").
        with(:body => { "object" => request.to_json },
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "sessionid": "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5" }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end

  def self.enable(name)
    request = { "params" => { "action" => "enable" }, get_type => { get_nsname_key => name }}
    stub_request(:post, "http://10.0.0.1/nitro/v1/config").
      with(:body => { "object" => request.to_json},
       :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie'=>'sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5'}).
       to_return({ :status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'}})
  end
  
  def self.disable(name)
    request = { "params" => { "action" => "disable" }, get_type => { get_nsname_key => name }}
    
    stub_request(:post, "http://10.0.0.1/nitro/v1/config").
      with(:body => { "object" => request.to_json },
        :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie'=>'sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5'}).
      to_return({ :status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'}})
  end
  
  def self.rename(name,newname)
    request = { "params" => { "action" => "rename" }, get_type => { get_nsname_key => name, "new" + get_nsname_key => newname }}
    stub_request(:post, "http://10.0.0.1/nitro/v1/config").
      with(:body => { "object" => request.to_json },
        :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie'=>'sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5'}).
       to_return({ :status => 200, :body => '{"errorcode": 0, "message": "Done"}', :headers => {'Content-Type' => 'application/json'}})
  end

  def self.delete(name)
    stub_request( :delete, "http://10.0.0.1/nitro/v1/config/#{get_type}/#{name}").
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie' => "sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"}).
      to_return({ :body => '{"errorcode": 0, "message": "Done"}', :status => 200, :headers => {'Content-Type' => 'application/json' }})
  end
  
  def self.logout
    stub_request( :post, "http://10.0.0.1/nitro/v1/config").
      with(:body => {"object"=>"{\"logout\":{}}"},
        :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'Cookie' => 'sessionid=##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5'}).
      to_return({ :body => '{"errorcode": 0, "message": "Bye!"}', :status => 200, :headers => {'Content-Type' => 'application/json'}})
  end
  
end