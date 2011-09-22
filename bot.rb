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

    def have_fit(m)
      (fit = rand(4)).times do
        message = cough
        m.reply(message) unless message.empty?
        m.reply("so sorry.") if fit == 4
      end
    end
  end

  on :message, /!help/ do |m|
    m.reply("To give me a command, prefix it with a bang (!). I know these commands:")
    m.reply("help: Show this message.")
    m.reply("cough: have a coughing fit on demand.")
    m.reply("wut: have occasional fits of my own accord.")
    m.reply("nah: stop having fits on my own.")
  end

  on :message, /!cough/ do |m|
    have_fit(m)
  end

  on :message, /!wut/ do |m|
    unless @cough
      @cough = true

      while @cough do
        have_fit(m)
        sleep(rand(1000) + 1000)
      end
    end
  end

  on :message, /!nah/ do |m|
    @cough = false

    m.reply("AHEM-hem. Excue me.")
  end
end

bot.start
