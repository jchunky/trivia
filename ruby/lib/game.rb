require_relative "category"
require_relative "game_displayer"
require_relative "player"

module UglyTrivia
  class Game
    attr_reader :players, :categories

    def initialize
      @players = []
      @categories = %w[Pop Science Sports Rock].map { |c| Category.new(c) }
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
      categories[current_player.location % categories.size]
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
