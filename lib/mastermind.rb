# frozen_string_literal: true

# The Mastermind class provides the interface to play a game of Master Mind
class Mastermind
  def start
    puts 'Please enter your next guess:'
    guess = gets.chomp
    puts 'Correct guess' if guess == '1111'
    puts 'Incorrect guess' unless guess == '1111'
  end
end
