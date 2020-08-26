require_relative "output"
require_relative "player"

module UglyTrivia
  class Game
    attr_reader :players, :output, :questions

    def initialize
      @players = []
      @output = Output.new(self)
      @questions = {
        "Pop" => 0,
        "Science" => 0,
        "Sports" => 0,
        "Rock" => 0,
      }
    end

    def add(player_name)
      players << Player.new(player_name, 0, 0, false)

      output.notify_new_player(players.last)
    end

    def roll(roll)
      output.notify_player_roll(roll)
      exit_penalty_box_if_able(roll)
      return if current_player.in_penalty_box

      current_player.location += roll
      current_player.location %= 12

      output.notify_new_category
      ask_question
    end

    def exit_penalty_box_if_able(roll)
      return unless current_player.in_penalty_box

      if roll.odd?
        current_player.in_penalty_box = false

        output.notify_getting_out_of_penalty_box
      else
        output.notify_remaining_in_penalty_box
      end
    end

    def was_correctly_answered
      unless current_player.in_penalty_box
        current_player.purse += 1
        output.notify_correct_answer
      end
      rotate_to_next_player
      !winner?
    end

    def wrong_answer
      output.notify_incorrect_answer
      current_player.in_penalty_box = true

      rotate_to_next_player
      !winner?
    end

    def current_player
      @players.first
    end

    def current_category
      questions.keys[current_player.location % questions.keys.size]
    end

    private

    def ask_question
      output.notify_new_question
      questions[current_category] += 1
    end

    def rotate_to_next_player
      @players.rotate!
    end

    def winner?
      @players.any?(&:winner?)
    end
  end
end
