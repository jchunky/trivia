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
    def initialize
      @questions = {
        "Pop" => 0,
        "Science" => 0,
        "Sports" => 0,
        "Rock" => 0,
      }

      @is_getting_out_of_penalty_box = false
      @players = []
    end

    def add(player_name)
      @players << Player.new(player_name)

      puts "#{player_name} was added"
      puts "They are player number #{@players.length}"

      true
    end

    def roll(roll)
      puts "#{current_player.name} is the current player"
      puts "They have rolled a #{roll}"

      if current_player.in_penalty_box
        if roll.odd?
          @is_getting_out_of_penalty_box = true

          puts "#{current_player.name} is getting out of the penalty box"
          current_player.location += roll
          current_player.location %= 12

          puts "#{current_player.name}'s new location is #{current_player.location}"
          puts "The category is #{current_category}"
          ask_question
        else
          puts "#{current_player.name} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
        end

      else

        current_player.location += roll
        current_player.location %= 12

        puts "#{current_player.name}'s new location is #{current_player.location}"
        puts "The category is #{current_category}"
        ask_question
      end
    end

    def was_correctly_answered
      if current_player.in_penalty_box
        if @is_getting_out_of_penalty_box
          puts "Answer was correct!!!!"
          current_player.purse += 1
          puts "#{current_player.name} now has #{current_player.purse} Gold Coins."

          goto_next_player
        else
          goto_next_player
        end
      else

        puts "Answer was corrent!!!!"
        current_player.purse += 1
        puts "#{current_player.name} now has #{current_player.purse} Gold Coins."

        goto_next_player
      end
      !winner?
    end

    def wrong_answer
      puts "Question was incorrectly answered"
      puts "#{current_player.name} was sent to the penalty box"
      current_player.in_penalty_box = true

      goto_next_player
      !winner?
    end

    private

    def goto_next_player
      @players.rotate!
    end

    def current_player
      @players.first
    end

    def ask_question
      puts "#{current_category} Question #{@questions[current_category]}"
      @questions[current_category] += 1
    end

    def current_category
      @questions.keys[current_player.location % @questions.keys.size]
    end

    def winner?
      @players.any?(&:winner?)
    end
  end
end
