require 'jumpstart_auth'

class JSTwitter
  attr_reader :client

  def initialize
    puts "Initializing"
    @client = JumpstartAuth.twitter
  end

  def tweet message
    if message.length > 140
      puts "Warning: Tweet is over 140 characters. Tweet rejected."
    else
      @client.update message
    end
  end

  def run
    puts "Welcome to JSL Twitter Client!"

    command = ""
    while command != "q"
      printf "enter command: "
      command, *message = gets.chomp.split
      case command
      when 'q'
        puts "Goodbye!"
      when 't'
        tweet message * " "
      else
        puts "Sorry, I don't know how to #{command}"
      end
    end
  end
end
