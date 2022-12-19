require "active_support/all"

module UglyTrivia
  class Player < Struct.new(:name, :location, :purse, :in_penalty_box)
    def initialize(name)
      super(name, 0, 0, false)
    end

    def move_to_location(roll)
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
      Game::CATEGORIES[location % 4]
    end
  end

  class Game
    CATEGORIES = %w[Pop Science Sports Rock]

    attr_reader :players, :question_index

    delegate :current_category, to: :current_player

    def initialize
      @players = []
      @question_index = CATEGORIES.to_h { |c| [c, 0] }
    end

    def add(player_name)
      players.push << Player.new(player_name)
      puts "#{player_name} was added"
      puts "They are player number #{players.size}"
    end

    def roll(roll)
      puts "#{current_player.name} is the current player"
      puts "They have rolled a #{roll}"
      check_if_player_leaving_penalty_box(roll)
      return if current_player.in_penalty_box

      current_player.move_to_location(roll)
      puts "#{current_player.name}'s new location is #{current_player.location}"
      puts "The category is #{current_category}"
      ask_question
    end

    def wrong_answer
      puts "Question was incorrectly answered"
      puts "#{current_player.name} was sent to the penalty box"
      current_player.enter_penalty_box
      advance_to_next_player
      !winner?
    end

    def was_correctly_answered
      unless current_player.in_penalty_box
        puts "Answer was corrent!!!!"
        current_player.answer_correctly
        puts "#{current_player.name} now has #{current_player.purse} Gold Coins."
      end
      advance_to_next_player
      !winner?
    end

    private

    def check_if_player_leaving_penalty_box(roll)
      return unless current_player.in_penalty_box

      if roll.odd?
        current_player.leave_penalty_box
        puts "#{current_player.name} is getting out of the penalty box"
      else
        puts "#{current_player.name} is not getting out of the penalty box"
      end
    end

    def ask_question
      puts "#{current_category} Question #{question_index[current_category]}"
      question_index[current_category] += 1
    end

    def current_player
      players.first
    end

    def advance_to_next_player
      players.rotate!
    end

    def winner?
      players.any?(:win?)
    end
  end
end
