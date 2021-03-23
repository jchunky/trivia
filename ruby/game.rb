module UglyTrivia
  class Player < Struct.new(:name, :location, :purse, :in_penalty_box)
    def initialize(name)
      super(name, 0, 0, false)
    end

    def winner?
      purse >= 6
    end
  end

  class Game
    attr_reader :players, :questions

    def initialize
      @players = []
      @questions = %w[Pop Science Sports Rock].map { |q| [q, 0] }.to_h
    end

    def add(player_name)
      players << Player.new(player_name)
      puts "#{player_name} was added"
      puts "They are player number #{players.length}"
    end

    def roll(roll)
      puts "#{current_player.name} is the current player"
      puts "They have rolled a #{roll}"
      check_whether_player_is_exiting_penalty_box(roll)
      return if current_player.in_penalty_box

      current_player.location += roll
      current_player.location %= 12
      puts "#{current_player.name}'s new location is #{current_player.location}"
      puts "The category is #{current_category}"
      ask_question
    end

    def check_whether_player_is_exiting_penalty_box(roll)
      return unless current_player.in_penalty_box

      if roll.odd?
        current_player.in_penalty_box = false
        puts "#{current_player.name} is getting out of the penalty box"
      else
        puts "#{current_player.name} is not getting out of the penalty box"
      end
    end

    def was_correctly_answered
      unless current_player.in_penalty_box
        puts "Answer was correct!!!!"
        current_player.purse += 1
        puts "#{current_player.name} now has #{current_player.purse} Gold Coins."
      end
      advance_to_next_player
      !winner?
    end

    def wrong_answer
      puts "Question was incorrectly answered"
      puts "#{current_player.name} was sent to the penalty box"
      current_player.in_penalty_box = true
      advance_to_next_player
      !winner?
    end

    private

    def advance_to_next_player
      players.rotate!
    end

    def current_player
      players.first
    end

    def winner?
      players.any?(&:winner?)
    end

    def is_playable?
      how_many_players >= 2
    end

    def how_many_players
      players.length
    end

    def ask_question
      puts "#{current_category} Question #{questions[current_category]}"
      questions[current_category] += 1
    end

    def current_category
      questions.keys[current_player.location % 4]
    end
  end
end
