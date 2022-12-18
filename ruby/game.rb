module UglyTrivia
  class Player < Struct.new(:name, :location, :purse, :in_penalty_box)
    def initialize(name)
      super(name, 0, 0, false)
    end

    def receive_round_winnings
      self.purse += 1
    end

    def move_to_penalty_box
      self.in_penalty_box = true
    end

    def leave_penalty_box
      self.in_penalty_box = false
    end

    def winner?
      purse >= 6
    end

    def advance_to_next_location(roll)
      self.location += roll
      self.location %= 12
    end
  end

  class Game
    CATEGORIES = %w[Pop Science Sports Rock]

    def initialize
      @players = []
      @question_index = CATEGORIES.to_h { |c| [c, 0] }
    end

    def add(player_name)
      @players << Player.new(player_name)
      puts "#{player_name} was added"
      puts "They are player number #{@players.size}"
    end

    def roll(roll)
      puts "#{current_player.name} is the current player"
      puts "They have rolled a #{roll}"
      check_if_getting_out_penalty_box(roll)
      return if current_player.in_penalty_box

      current_player.advance_to_next_location(roll)
      puts "#{current_player.name}'s new location is #{current_player.location}"
      puts "The category is #{current_category}"
      ask_question
    end

    def was_correctly_answered
      unless current_player.in_penalty_box
        puts "Answer was correct!!!!"
        current_player.receive_round_winnings
        puts "#{current_player.name} now has #{current_player.purse} Gold Coins."
      end
      advance_to_next_player
      !winner?
    end

    def wrong_answer
      puts "Question was incorrectly answered"
      current_player.move_to_penalty_box
      puts "#{current_player.name} was sent to the penalty box"
      advance_to_next_player
      !winner?
    end

    private

    def check_if_getting_out_penalty_box(roll)
      return unless current_player.in_penalty_box

      if roll.even?
        puts "#{current_player.name} is not getting out of the penalty box"
      else
        puts "#{current_player.name} is getting out of the penalty box"
        current_player.leave_penalty_box
      end
    end

    def winner?
      @players.any?(&:winner?)
    end

    def current_player
      @players.first
    end

    def advance_to_next_player
      @players.rotate!
    end

    def ask_question
      question = "#{current_category} Question #{@question_index[current_category]}"
      @question_index[current_category] += 1
      puts question
    end

    def current_category
      CATEGORIES[current_player.location % CATEGORIES.size]
    end
  end
end
