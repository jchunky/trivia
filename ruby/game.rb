module UglyTrivia
  class Player < Struct.new(:name, :place, :purse, :in_penalty_box)
    def initialize(name)
      super(name, 0, 0, false)
    end
  end

  class Game
    CATEGORIES = %w[Pop Science Sports Rock]
    def initialize
      @questions = Hash.new(0)
      @players = []
      @is_getting_out_of_penalty_box = false
      @current_player = 0
    end

    def create_rock_question(index)
      "Rock Question #{index}"
    end

    def is_playable?
      how_many_players >= 2
    end

    def add(player_name)
      @players << Player.new(player_name)

      puts "#{player_name} was added"
      puts "They are player number #{@players.size}"

      true
    end

    def how_many_players
      @players.size
    end

    def roll(roll)
      puts "#{current_player.name} is the current player"
      puts "They have rolled a #{roll}"

      if current_player.in_penalty_box
        if roll.odd?
          @is_getting_out_of_penalty_box = true

          puts "#{current_player.name} is getting out of the penalty box"
          current_player.place += roll
          current_player.place %= 12

          puts "#{current_player.name}'s new location is #{current_player.place}"
          puts "The category is #{current_category}"
          ask_question
        else
          puts "#{current_player.name} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
        end

      else

        current_player.place += roll
        current_player.place %= 12

        puts "#{current_player.name}'s new location is #{current_player.place}"
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

          winner = did_player_win
          advance_to_next_player

          winner
        else
          advance_to_next_player
          true
        end

      else

        puts "Answer was corrent!!!!"
        current_player.purse += 1
        puts "#{current_player.name} now has #{current_player.purse} Gold Coins."

        winner = did_player_win
        advance_to_next_player

        winner
      end
    end

    def wrong_answer
      puts "Question was incorrectly answered"
      puts "#{current_player.name} was sent to the penalty box"
      current_player.in_penalty_box = true

      advance_to_next_player
      true
    end

    private

    def advance_to_next_player
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
      CATEGORIES[current_player.place % 4]
    end

    def did_player_win
      current_player.purse != 6
    end
  end
end
