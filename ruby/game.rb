require "active_support/all"

module UglyTrivia
  class Player < Struct.new(:name, :location, :purse, :in_penalty_box)
    alias to_s name

    def initialize(name)
      super(name, 0, 0, false)
    end

    def advance_location(roll)
      self.location += roll
      self.location %= 12
    end

    def answer_correctly
      self.purse += 1
    end

    def win?
      purse >= 6
    end

    def enter_penalty_box
      self.in_penalty_box = true
    end

    def leave_penalty_box
      self.in_penalty_box = false
    end

    def current_category
      Game::CATEGORIES[location % Game::CATEGORIES.size]
    end
  end

  class Questions
    attr_reader :index

    def initialize
      @index = Hash.new(0)
    end

    def next_question_for(category)
      result = "#{category} Question #{index[category]}"
      index[category] += 1
      result
    end
  end

  class Game
    CATEGORIES = %w[Pop Science Sports Rock]

    attr_reader :players, :questions

    delegate :current_category, to: :current_player

    def initialize
      @players = []
      @questions = Questions.new
    end

    def add(player_name)
      players.push << Player.new(player_name)
      puts "#{player_name} was added"
      puts "They are player number #{players.size}"
    end

    def roll(roll)
      puts "#{current_player} is the current player"
      puts "They have rolled a #{roll}"
      check_if_player_leaving_penalty_box(roll)
      return if current_player.in_penalty_box

      current_player.advance_location(roll)
      puts "#{current_player}'s new location is #{current_player.location}"
      puts "The category is #{current_category}"
      puts questions.next_question_for(current_category)
    end

    def wrong_answer
      puts "Question was incorrectly answered"
      puts "#{current_player} was sent to the penalty box"
      current_player.enter_penalty_box
      advance_to_next_player
      continue_game?
    end

    def was_correctly_answered
      unless current_player.in_penalty_box
        puts "Answer was corrent!!!!"
        current_player.answer_correctly
        puts "#{current_player} now has #{current_player.purse} Gold Coins."
      end
      advance_to_next_player
      continue_game?
    end

    private

    def check_if_player_leaving_penalty_box(roll)
      return unless current_player.in_penalty_box

      if roll.odd?
        current_player.leave_penalty_box
        puts "#{current_player} is getting out of the penalty box"
      else
        puts "#{current_player} is not getting out of the penalty box"
      end
    end

    def current_player
      players.first
    end

    def advance_to_next_player
      players.rotate!
    end

    def continue_game?
      players.none?(:win?)
    end
  end
end
