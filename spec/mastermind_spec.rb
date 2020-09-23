# frozen_string_literal: true

require 'mastermind'
require 'renderer_spy'

def generate_guesses(range)
  colors = range.to_a * 4
  colors.combination(4).to_a
end

def generate_invalid_guesses(range)
  invalid_guesses = Set.new(generate_guesses(0..9)) -
                    Set.new(generate_guesses(range))
  invalid_guesses.add(('6' * 5).split(''))
  invalid_guesses
end

RSpec.describe Mastermind do
  subject(:renderer) { RendererSpy.new }
  subject(:renderer_class) { renderer.class }
  subject(:game) { described_class.new(renderer) }
  let(:invalid_guesses) { generate_invalid_guesses(1..6) }
  let(:correct_guesses) { generate_guesses(1..6) }

  context 'player is codebreaker' do
    describe '#make_player_guess' do
      it 'asks for guesses until a correct guess is provided' do
        expected_output = [renderer_class::MAKE_GUESS,
                           renderer_class::INVALID_GUESS,
                           renderer_class::MAKE_GUESS,
                           renderer_class::CORRECT_GUESS]

        invalid_guesses.each do |invalid_guess|
          correct_guess = correct_guesses.sample.join('')
          allow(renderer).to receive(:gets).and_return(invalid_guess.join(''),
                                                       correct_guess)
          renderer.displayed_msgs.clear

          game.make_player_guess
          expect(renderer.displayed_msgs).to eq expected_output
        end
      end
    end

    describe '#rate_guess' do
      it 'rates a guess with no similarites to the secret with 0 pegs' do
        expected_output = ['Your guess received 0 black pegs.',
                           'Your guess received 0 white pegs.']
        guess = correct_guesses.sample.join('')
        allow(renderer).to receive(:gets).and_return(guess)

        game.rate_guess
        expect(renderer.displayed_msgs).to eq expected_output
      end
    end
  end
end
