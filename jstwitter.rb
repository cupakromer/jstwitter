require 'jumpstart_auth'
require 'bitly'

class Twitter::User
  def last_tweet_date
    status.created_at.strftime "%A, %b, %d"
  end

  def last_tweet
    status.text
  end
end

class JSTwitter
  def initialize
    puts "Initializing"
    @client = JumpstartAuth.twitter
    Bitly.use_api_version_3
    @bitly = Bitly.new 'hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6'
  end

  def followers_screen_names_from_server
    client.followers.collect{|follower| follower.screen_name}
  end

  def friends_list_from_server
    client.friends.sort_by{|f| f.screen_name.downcase}
  end

  def tweet message
    if message.length > 140
      puts "Warning: Tweet is over 140 characters. Tweet rejected."
    else
      client.update message
    end
  end

  def dm target, message
    if followers_screen_names_from_server.include? target
      tweet "d #{target} #{message}"
    else
      puts "Sorry, you must follow #{target} first."
    end
  end

  def spam_my_soon_to_be_ex_friends message
    followers = followers_screen_names_from_server

    puts "You have no followers. That's sad." if followers.empty?

    followers.each do |follower|
      puts "Spamming #{follower}..."
      dm follower, message
    end
  end

  def everyones_last_tweet
    friends = friends_list_from_server

    puts "You have no friends. You should fix that." if friends.empty?

    friends.each do |friend|
      puts "#{friend.screen_name} said this on #{friend.last_tweet_date}...\n"
      puts "    \"#{friend.last_tweet}\""
      puts ""   # Just print a blank line to separate people
    end
  end

  def run
    puts "Welcome to JSL Twitter Client!"

    command = ""
    while command != "q"
      printf "enter command: "
      command, *message = gets.chomp.split

      case command
      when 'q'    ; puts "Goodbye!"
      when 't'    ; tweet message * " "
      when 'dm'   ; dm message.shift, message * " "
      when 'spam' ; spam_my_soon_to_be_ex_friends message * " "
      when 'fol'  ; puts followers_screen_names_from_server
      when 'frl'  ; puts friends_list_from_server
      when 'elt'  ; everyones_last_tweet
      when 'turl' ; tweet shorten_all_urls(message) * " "
      else puts "Sorry, I don't know how to #{command}"
      end
    end
  end

private
  def shorten_url url
    @bitly.shorten(url).short_url
  end

  def shorten_if_url string
    string =~ /^http:/ ? shorten_url(string) : string
  end

  def shorten_all_urls words
    words.collect{|w| shorten_if_url w} 
  end

  attr_reader :client, :bitly
end

jst = JSTwitter.new
jst.run
