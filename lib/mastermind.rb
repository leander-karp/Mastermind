# frozen_string_literal: true

require_relative 'renderer'

# The Mastermind class provides the interface to play a game of Master Mind
class Mastermind
  def rate_guess
    puts 'Your guess received no pegs.'
  end

  def make_player_guess
    guess = render_make_guess
    while !verify_guess(guess)
      Renderer.print 'Invalid guess'
      guess = render_make_guess
    end
    Renderer.print 'Correct guess'
    
  end

  private

  def render_make_guess
    Renderer.input 'Please enter your next guess:'
  end

  def verify_guess(guess)
    return false if guess.size != 4
    guess.split('').map do |char|
      (1..6).include?(char.to_i)
    end.all?
  end
end
