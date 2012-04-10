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

  def dm target, message
    puts "Trying to send #{target} this direct message: \"#{message}\""

    if @client.followers.collect{|follower| follower.screen_name}.include? target
      tweet "d #{target} #{message}"
    else
      puts "Sorry, you must follow #{target} first."
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
      when 'dm'
        dm message.shift, message * " "
      else
        puts "Sorry, I don't know how to #{command}"
      end
    end
  end
end
