module Netscaler
  attr_reader :hostname

  class Connection
    def initialize(options = {})
      raise ArgumentError unless options.is_a? Hash
      raise ArgumentError unless options.count.eql? 3
      %w(username password hostname).each { |k| raise ArgumentError unless options.has_key? k }

      @username = options["username"]
      @password = options["password"]
      @hostname = options["hostname"]
    end
  end
end
