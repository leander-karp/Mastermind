# frozen_string_literal: true

# Simple console IO-Wrapper
class Renderer
  INVALID_GUESS = 'Invalid guess'
  CORRECT_GUESS = 'Correct guess'
  MAKE_GUESS = 'Please enter your next guess:'
  RATING = 'Your guess received %s %s pegs.'
  NO_PAST_GUESSES = 'There aren\'t any past guesses.'
  PAST_GUESSES = 'You made the following guesses:'

  def display_invalid_guess
    display INVALID_GUESS
  end

  def display_correct_guess
    display CORRECT_GUESS
  end

  def display_rating(number_of_pegs, color)
    display format(RATING, number_of_pegs, color)
  end

  def input_guess
    input MAKE_GUESS
  end

  def display_guesses(guesses = [])
    display(guesses.empty? ? NO_PAST_GUESSES : PAST_GUESSES)
    guesses.each_with_index do |guess, index|
      display format('%<index>i. %<guess>s', { index: index+1, guess: guess })
    end
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
