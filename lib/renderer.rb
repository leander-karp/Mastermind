# frozen_string_literal: true

# Simple console IO-Wrapper
class Renderer
  INVALID_GUESS = 'Invalid guess'
  CORRECT_GUESS = 'Correct guess'
  MAKE_GUESS = 'Please enter your next guess:'

  def display_invalid_guess
    display INVALID_GUESS
  end

  def display_correct_guess
    display CORRECT_GUESS
  end

  def display_rating(number_of_pegs, color)
    display "Your guess received #{number_of_pegs} #{color} pegs."
  end

  def input_guess
    input MAKE_GUESS
  end

  private

  def input(msg)
    display msg
    gets.chomp
  end

  def display(msg)
    puts msg
  end
end
