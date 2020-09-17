# frozen_string_literal: true
require 'renderer'

# The Mastermind class provides the interface to play a game of Master Mind
class Mastermind
  def start
    Renderer.print('Do you want to be the codebreaker?')
    player_decision = gets.chomp
    if player_decision == 'yes'
      Renderer.print('Please enter your first guess:')
    elsif player_decision == 'no'
      Renderer.print('Please set your secret code:')
    end
  end
end
