# frozen_string_literal: true

# The Mastermind class provides the interface to play a game of Master Mind
class Mastermind
  def start
    puts 'Do you want to be the codebreaker?'
    player_decision = gets.chomp
    if player_decision == 'yes'
      puts 'Please enter your first guess:'
    elsif player_decision == 'no'
      puts 'Please set your secret code:'
    end
  end
end
