require_relative "game_displayer"
require_relative "player"

module UglyTrivia
  class Game
    attr_reader :players, :questions

    def initialize
      @players = []
      @questions = %w[Pop Science Sports Rock].map { |q| [q, 0] }.to_h
    end

    def add(player_name)
      players << Player.new(player_name)
      output.add_player(player_name)
    end

    def roll(roll)
      output.player_rolls(roll)
      check_whether_player_exiting_penalty_box(roll)
      return if current_player.in_penalty_box

      current_player.location += roll
      current_player.location %= 12
      output.ask_player_question
      questions[current_category] += 1
    end

    def check_whether_player_exiting_penalty_box(roll)
      return unless current_player.in_penalty_box

      if roll.odd?
        current_player.in_penalty_box = false
        output.player_exists_penalty_box
      else
        output.player_stays_in_penalty_box
      end
    end

    def was_correctly_answered
      unless current_player.in_penalty_box
        current_player.purse += 1
        output.player_answers_correctly
      end
      advance_to_next_player
      !winner?
    end

    def wrong_answer
      output.player_answers_incorrectly
      current_player.in_penalty_box = true
      advance_to_next_player
      !winner?
    end

    def current_player
      players.first
    end

    def current_category
      questions.keys[current_player.location % 4]
    end

    private

    def advance_to_next_player
      players.rotate!
    end

    def winner?
      players.any?(&:winner?)
    end

    def output
      @output ||= GameDisplayer.new(self)
    end
  end
end
