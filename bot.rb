require 'bundler'
Bundle.require

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = [ENV['CHANNEL']]
    c.nick = 'TCG'
  end

  on :message, /!wut/ do |m|
    channel = m.channel

    raw('wut')
  end
end

bot.start
