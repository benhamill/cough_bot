require 'bundler'
Bundler.require

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = [ENV['CHANNEL']]
    c.nick = '_T_C_G_'

    @cough = false
    @coughs = %w{COUGH cough AHEM ahem HACK hack harrumph hmm-hmm hmm-HMM HMM-hmm ahem-hem AHEM-hem ahem-HEM AHEM-HEM coughcough COUGHcough coughCOUGH HRRRRRGGGRRRHRHHRHRHRHRGGGXHHG}
  end

  helpers do
    def cough
      (1..rand(10)).inject('') do |memo, number|
        memo << ([@coughs.sample] * rand(5)).join(' ') + ' '
      end.gsub(/^ +/, '').gsub(/ +$/, '').gsub(/  +/, '')
    end
  end

  on :message, /!wut/ do |m|
    @cough = true

    while @cough do
      (fit = rand(4)).times do
        message = cough
        m.reply(message) unless message.empty?
        m.reply("so sorry.") if fit == 4
      end

      sleep(rand(1000) + 1000)
    end
  end

  on :message, /!nah/ do |m|
    @cough = false

    m.reply("AHEM-hem. Excue me.")
  end
end

bot.start
