module UglyTrivia
  class Player < Struct.new(:name, :location, :purse, :in_penalty_box)
    def initialize(name)
      super(name, 0, 0, false)
    end

    def winner?
      purse >= 6
    end

    def advance_location(roll)
      self.location += roll
      self.location %= 12
    end
  end

  class Category < Struct.new(:name, :index)
    alias to_s name

    def initialize(name)
      super(name, 0)
    end

    def next_question
      result = "#{name} Question #{index}"
      self.index += 1
      result
    end
  end

  class Categories
    CATEGORIES = %w[Pop Science Sports Rock]

    attr_reader :categories

    def initialize
      @categories = CATEGORIES.map { |category_name| Category.new(category_name) }
    end

    def category_at_location(location)
      categories[location % categories.count]
    end
  end

  class Game
    attr_reader :categories, :players

    def initialize
      @players = []
      @categories = Categories.new
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

      current_player.advance_location(roll)
      category = categories.category_at_location(current_player.location)
      question = category.next_question
      puts "#{current_player.name}'s new location is #{current_player.location}"
      puts "The category is #{category}"
      puts question
    end

    def was_correctly_answered
      unless current_player.in_penalty_box
        current_player.purse += 1
        puts "Answer was correct!!!!"
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

    def game_over?
      players.any?(:winner?)
    end

    def current_player
      players.first
    end
  end
end
