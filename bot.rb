require 'bundler'
Bundler.require

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = [ENV['CHANNEL']]
    c.nick = 'osmbot'

    @coughs = %w{COUGH cough AHEM ahem HACK hack harrumph hmm-hmm hmm-HMM HMM-hmm ahem-hem AHEM-hem ahem-HEM AHEM-HEM coughcough COUGHcough coughCOUGH HRRRRRGGGRRRHRHHRHRHRHRGGGXHHG}
  end

  helpers do
    def cough
      (1..roll(3)).inject('') do |memo, number|
        memo << ([@coughs.sample] * roll(4)).join(' ') + ' '
      end.gsub(/^ +/, '').gsub(/ +$/, '').gsub(/  +/, ' ')
    end

    def cough_on(nick, m)
      (fit = roll(4)).times do
        message = cough
        m.reply("#{nick}: #{message}") unless message.empty?
      end

      m.reply("#{nick}: Excuse me.") if fit == 4
    end

    def roll(number)
      rand(number) + 1
    end

    def commands(command, m)
      if command =~ /cough on (\w+)/
        cough_on($1, m)
      else
        :noop
      end
    end

    def q_word_lookup(letter)
      {
        'O' => 'Who',
        'N' => 'When',
        'W' => 'What',
        'H' => 'How',
        'Y' => 'Why',
        'R' => 'Where',
      }[letter]
    end
  end

  on :message, /^#{self.nick}\:? +(.*)/ do |m, command|
    commands(command, m)
  end

  on :message, /([OWNRHY])TF/ do |m, letter|
    m.reply "Hey, YEAH! #{q_word_lookup(letter)} the FUCK?!?!"
  end

  on :message, /maron/i do |m|
    m.reply "Seriously."
  end
end

bot.start
