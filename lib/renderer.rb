# frozen_string_literal: true

# Simple console IO-Wrapper
class Renderer
  INVALID_CODE = 'Invalid code'
  MAKE_GUESS = 'Please enter your next guess:'
  RATING = 'The guess received %s %s pegs.'
  NO_GUESSES_EXIST = 'There aren\'t any past guesses.'
  GUESSES_EXIST = 'These are the past guesses:'
  WELCOME_MSG = "Welcome to Mastermind.
You may select whether you wish to be codemaker or codebreaker.
A correct guess consists of 4 numbers between 1 to 6, e.g. '1111'."
  CODEBREAKER_QUESTION = 'Do you want to be the codebreaker (y/n)?'
  SELECT_SECRET_MSG = 'Please enter the secret code:'
  COMPUTER_GUESS = 'The computer guessed: %s'

  def display_invalid_code
    display INVALID_CODE
  end

  def display_rating(number_of_pegs, color)
    display format(RATING, number_of_pegs, color)
  end

  def display_welcome_msg
    display WELCOME_MSG
  end

  def input_guess
    input MAKE_GUESS
  end

  def choose_role
    input CODEBREAKER_QUESTION
  end

  def display_guesses(guesses = [])
    display(guesses.empty? ? NO_GUESSES_EXIST : GUESSES_EXIST)
    guesses.each_with_index do |guess, index|
      display "#{index + 1}. #{guess}"
    end
  end

  def display_computer_guess(guess)
    display COMPUTER_GUESS % guess
  end

  def select_secret
    input SELECT_SECRET_MSG
  end

  private

  def input(msg)
    display msg
    gets.chomp.strip
  end

  def display(msg)
    puts msg
  end
end
