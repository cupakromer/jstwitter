require 'jumpstart_auth'

class JSTwitter
  attr_reader :client

  def initialize
    puts "Initializing"
    @client = JumpstartAuth.twitter
  end

  def tweet message
    @client.update message
  end
end
