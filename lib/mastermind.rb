# frozen_string_literal: true

# The Mastermind class provides the interface to play a game of Master Mind
class Mastermind
  def start
    player_guesses
  end

  private 

  def player_guesses
    puts 'Please enter your next guess:'
    guess = gets.chomp

    while !((1111..6666).include?(guess.to_i)) || guess.include?('0')
      puts 'Invalid guess' 
      puts 'Please enter your next guess:'
      guess = gets.chomp
    end
    puts 'Correct guess' 
  end
end
