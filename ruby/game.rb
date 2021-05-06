module UglyTrivia
  class Player < Struct.new(:name, :place, :purse, :in_penalty_box)
    def initialize(name)
      super(name, 0, 0, false)
    end

    def winner?
      purse >= 6
    end
  end

  class Game
    CATEGORIES = %w[Pop Science Sports Rock]

    attr_reader :players

    def initialize
      @players = []
      @questions = CATEGORIES.map { |category| [category, 0] }.to_h
    end

    def add(player_name)
      players << Player.new(player_name)
      puts "#{player_name} was added"
      puts "They are player number #{players.count}"
    end

    def roll(roll)
      puts "#{current_player.name} is the current player"
      puts "They have rolled a #{roll}"
      check_whether_player_exiting_penalty_box(roll)
      return if current_player.in_penalty_box

      current_player.place += roll
      current_player.place %= 12
      puts "#{current_player.name}'s new location is #{current_player.place}"
      puts "The category is #{current_category}"
      question_number = @questions[current_category]
      puts "#{current_category} Question #{question_number}"
      @questions[current_category] += 1
    end

    def was_correctly_answered
      unless current_player.in_penalty_box
        puts "Answer was correct!!!!"
        current_player.purse += 1
        puts "#{current_player.name} now has #{current_player.purse} Gold Coins."
      end
      advance_to_next_player
      !game_over?
    end

    def wrong_answer
      puts "Question was incorrectly answered"
      puts "#{current_player.name} was sent to the penalty box"
      current_player.in_penalty_box = true
      advance_to_next_player
      !game_over?
    end

    private

    def check_whether_player_exiting_penalty_box(roll)
      return unless current_player.in_penalty_box

      if roll.odd?
        current_player.in_penalty_box = false
        puts "#{current_player.name} is getting out of the penalty box"
      else
        puts "#{current_player.name} is not getting out of the penalty box"
      end
    end

    def advance_to_next_player
      players.rotate!
    end

    def current_player
      players.first
    end

    def game_over?
      players.any?(:winner?)
    end

    def current_category
      CATEGORIES[current_player.place % CATEGORIES.count]
    end
  end
end
