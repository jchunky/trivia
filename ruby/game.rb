module UglyTrivia
  class Questions
    attr_reader :questions

    def initialize
      @questions = Hash.new(0)
    end

    def next_question(category)
      number = questions[category]
      question = "#{category} Question #{number}"
      questions[category] += 1
      question
    end
  end

  class Player < Struct.new(:name, :place, :purse, :in_penalty_box)
    def initialize(name)
      super(name, 0, 0, false)
    end
  end

  class Game
    MAX_PLAYERS = 6
    WINNING_SCORE = 6
    BOARD_SIZE = 12

    attr_reader :questions, :players

    def initialize
      @players = []
      @questions = Questions.new
      @is_getting_out_of_penalty_box = false
    end

    def add(player_name)
      @players << Player.new(player_name)
      players.count

      puts "#{player_name} was added"
      puts "They are player number #{players.count}"

      true
    end

    def roll(roll)
      puts "#{current_player_name} is the current player"
      puts "They have rolled a #{roll}"

      if in_penalty_box?
        handle_penalty_box(roll)
      else
        move_player(roll)
        ask_question
      end
    end

    def was_correctly_answered
      if in_penalty_box?
        return unless @is_getting_out_of_penalty_box
      end

      puts "Answer was correct!!!!"
      current_player.purse += 1
      puts "#{current_player_name} now has #{current_player.purse} Gold Coins."
    ensure
      next_turn
      return !did_player_win?
    end

    def wrong_answer
      puts "Question was incorrectly answered"
      puts "#{current_player_name} was sent to the penalty box"
      current_player.in_penalty_box = true
    ensure
      next_turn
      return !did_player_win?
    end

    private

    def current_player_name
      current_player.name
    end

    def in_penalty_box?
      current_player.in_penalty_box
    end

    def move_player(roll)
      current_player.place = (current_player.place + roll) % BOARD_SIZE
      puts "#{current_player_name}'s new location is #{current_player.place}"
      puts "The category is #{current_category}"
    end

    def handle_penalty_box(roll)
      if roll.odd?
        @is_getting_out_of_penalty_box = true
        puts "#{current_player_name} is getting out of the penalty box"
        move_player(roll)
        ask_question
      else
        puts "#{current_player_name} is not getting out of the penalty box"
        @is_getting_out_of_penalty_box = false
      end
    end

    def ask_question
      question = questions.next_question(current_category)
      puts question
    end

    def current_player
      players.first
    end

    def current_category
      %w[Pop Science Sports Rock][current_player.place % 4]
    end

    def did_player_win?
      players.any? { |player| player.purse >= WINNING_SCORE }
    end

    def next_turn
      players.rotate!
    end
  end
end
