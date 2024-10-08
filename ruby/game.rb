module UglyTrivia
  class Questions
    attr_reader :questions

    def initialize
      @questions = Hash.new(0)
    end

    def next_question(category)
      question_number = questions[category]
      questions[category] += 1
      "#{category} Question #{question_number}"
    end
  end

  class Player < Struct.new(:name, :location, :purse, :in_penalty_box)
    WINNING_SCORE = 6
    BOARD_SIZE = 12

    def initialize(name)
      super(name, 0, 0, false)
    end

    def move_forward(roll)
      self.location = (location + roll) % BOARD_SIZE
    end

    def enter_penalty_box
      self.in_penalty_box = true
    end

    def exit_penalty_box
      self.in_penalty_box = false
    end

    def increase_purse
      self.purse += 1
    end

    def win?
      purse >= WINNING_SCORE
    end

    def in_penalty_box?
      in_penalty_box
    end

    def current_category
      %w[Pop Science Sports Rock][location % 4]
    end
  end

  class Game
    attr_reader :questions, :players

    def initialize
      @players = []
      @questions = Questions.new
    end

    def add(player_name)
      @players << Player.new(player_name)
      puts "#{player_name} was added"
      puts "They are player number #{players.count}"
    end

    def roll(roll)
      puts "#{current_player.name} is the current player"
      puts "They have rolled a #{roll}"
      handle_penalty_box(roll)
      return if current_player.in_penalty_box?

      move_player(roll)
      ask_question
    end

    def was_correctly_answered
      unless current_player.in_penalty_box?
        puts "Answer was correct!!!!"
        current_player.increase_purse
        puts "#{current_player.name} now has #{current_player.purse} Gold Coins."
      end
      next_turn
      !game_over?
    end

    def wrong_answer
      puts "Question was incorrectly answered"
      puts "#{current_player.name} was sent to the penalty box"
      current_player.enter_penalty_box
      next_turn
      !game_over?
    end

    private

    def move_player(roll)
      current_player.move_forward(roll)
      puts "#{current_player.name}'s new location is #{current_player.location}"
      puts "The category is #{current_player.current_category}"
    end

    def handle_penalty_box(roll)
      return unless current_player.in_penalty_box?

      if roll.odd?
        puts "#{current_player.name} is getting out of the penalty box"
        current_player.exit_penalty_box
      else
        puts "#{current_player.name} is not getting out of the penalty box"
      end
    end

    def ask_question
      puts questions.next_question(current_player.current_category)
    end

    def current_player
      players.first
    end

    def game_over?
      players.any?(&:win?)
    end

    def next_turn
      players.rotate!
    end
  end
end
