# frozen_string_literal: true

require_relative 'renderer'

# The Mastermind class provides the interface to play a game of Master Mind
class Mastermind
  attr_reader :renderer

  def initialize(renderer)
    @renderer = renderer
  end

  def rate_guess
    renderer.display_rating(0, 'black')
    renderer.display_rating(0, 'white')
  end

  def make_player_guess
    renderer.display_invalid_guess until verify_guess(renderer.input_guess)
    renderer.display_correct_guess
  end

  private

  def verify_guess(guess)
    return false if guess.size != 4

    guess.split('').map do |char|
      (1..6).include?(char.to_i)
    end.all?
  end
end
