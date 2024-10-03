module UglyTrivia
  class Player < Struct.new(:name, :place, :purse, :in_penalty_box)
    def initialize(name)
      super(name, 0, 0, false)
    end

    def enter_penalty_box
      self.in_penalty_box = true
    end

    def leave_penalty_box
      self.in_penalty_box = false
    end

    def earns_money
      self.purse += 1
    end

    def winner?
      purse >= 6
    end

    def move(roll)
      self.place = (place + roll) % 12
    end

    def current_category
      Questions::CATEGORIES[place % 4]
    end
  end

  class Questions
    CATEGORIES = %w[Pop Science Sports Rock]

    attr_reader :questions

    def initialize
      @questions = Hash.new(0)
    end

    def next_question(category)
      result = "#{category} Question #{questions[category]}"
      questions[category] += 1
      result
    end
  end

  class Game
    attr_reader :players, :questions

    def initialize
      @players = []
      @questions = Questions.new
    end

    def add(player_name)
      players << Player.new(player_name)
      puts "#{player_name} was added"
      puts "They are player number #{players.count}"
    end

    def roll(roll)
      puts "#{current_player.name} is the current player"
      puts "They have rolled a #{roll}"
      handle_penalty_box(roll)
      return if current_player.in_penalty_box

      current_player.move(roll)
      puts "#{current_player.name}'s new location is #{current_player.place}"
      puts "The category is #{current_category}"
      ask_question
    end

    def was_correctly_answered
      return if current_player.in_penalty_box

      puts "Answer was correct!!!!"
      current_player.earns_money
      puts "#{current_player.name} now has #{current_player.purse} Gold Coins."
    ensure
      advance_to_next_player
      has_winner?
    end

    def wrong_answer
      puts "Question was incorrectly answered"
      current_player.enter_penalty_box
      puts "#{current_player.name} was sent to the penalty box"
    ensure
      advance_to_next_player
      has_winner?
    end

    private

    def handle_penalty_box(roll)
      return unless current_player.in_penalty_box

      is_getting_out_of_penalty_box = roll.odd?
      if is_getting_out_of_penalty_box
        puts "#{current_player.name} is getting out of the penalty box"
        player.leave_penalty_box
      else
        puts "#{current_player.name} is not getting out of the penalty box"
      end
    end

    def advance_to_next_player
      players.rotate!
    end

    def ask_question
      puts questions.next_question(current_category)
    end

    def has_winner?
      players.any?(&:winner?)
    end

    def current_category
      current_player.current_category
    end

    def current_player
      players.first
    end
  end
end
