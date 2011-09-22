require 'bundler'
Bundler.require

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = [ENV['CHANNEL']]
    c.nick = 'TCG'
  end

  on :message, /!wut/ do |m|
    m.reply 'yeeeeeeeaaaaaaaaaaah'
    # raw('wut')
  end
end

bot.start
