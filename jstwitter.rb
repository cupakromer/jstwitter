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

    if followers_list.include? target
      tweet "d #{target} #{message}"
    else
      puts "Sorry, you must follow #{target} first."
    end
  end

  def followers_list
    @client.followers.collect{|follower| follower.screen_name}
  end

  def spam_my_soon_to_be_ex_friends message
    followers_list.each do |follower|
      puts "Spamming #{follower}..."
      dm follower, message
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
      when 'spam'
        spam_my_soon_to_be_ex_friends message * " "
      when 'fl'
        puts followers_list
      else
        puts "Sorry, I don't know how to #{command}"
      end
    end
  end
end

jst = JSTwitter.new
jst.run
