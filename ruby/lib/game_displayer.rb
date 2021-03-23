require "delegate"

class GameDisplayer < SimpleDelegator
  def add_player(player_name)
    puts "#{player_name} was added"
    puts "They are player number #{players.length}"
  end

  def player_rolls(roll)
    puts "#{current_player.name} is the current player"
    puts "They have rolled a #{roll}"
  end

  def ask_player_question
    puts "#{current_player.name}'s new location is #{current_player.location}"
    puts "The category is #{current_category}"
    puts "#{current_category} Question #{questions[current_category]}"
  end

  def player_stays_in_penalty_box
    puts "#{current_player.name} is not getting out of the penalty box"
  end

  def player_exists_penalty_box
    puts "#{current_player.name} is getting out of the penalty box"
  end

  def player_answers_correctly
    puts "Answer was correct!!!!"
    puts "#{current_player.name} now has #{current_player.purse} Gold Coins."
  end

  def player_answers_incorrectly
    puts "Question was incorrectly answered"
    puts "#{current_player.name} was sent to the penalty box"
  end
end
