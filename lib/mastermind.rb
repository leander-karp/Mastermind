# frozen_string_literal: true

# The Mastermind class provides the interface to play a game of Master Mind
class Mastermind
  def start
    puts 'Please enter your next guess:'
    guess = gets.chomp
    if (1111..6666).include?(guess.to_i)
      puts 'Correct guess' 
    else 
      puts 'Incorrect guess' 
    end
  end
end
