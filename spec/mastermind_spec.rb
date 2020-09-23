# frozen_string_literal: true

require 'mastermind'
require 'renderer'

def generate_guesses(range)
  colors = range.to_a * 4
  colors.combination(4).to_a
end

def generate_invalid_guesses(range)
  invalid_guesses = Set.new(generate_guesses(0..9)) - 
  Set.new(generate_guesses(range))
  invalid_guesses.add(('6'*5).split(''))
  invalid_guesses
end

RSpec.describe Mastermind do
  subject(:game) { described_class.new }
  let(:invalid_guesses) { generate_invalid_guesses(1..6) }
  let(:correct_guesses) { generate_guesses(1..6) }

  context 'player is codebreaker' do
    describe '#make_player_guess' do
      let(:next_guess_msg) { "Please enter your next guess:\n" }
      let(:correct_guess_msg) { "Correct guess\n" }
      let(:invalid_guess_msg) { "Invalid guess\n" }

      it 'asks for guesses until a correct guess is provided' do
        expected_output = next_guess_msg + invalid_guess_msg + \
                          next_guess_msg + correct_guess_msg

        invalid_guesses.each do |invalid_guess|
          correct_guess = correct_guesses.sample.join('')
          allow(Renderer).to receive(:gets).and_return(invalid_guess.join(''),
                                                       correct_guess)

          expect { game.make_player_guess }.to output(expected_output).to_stdout
        end
      end

      describe '#rate_guess'
      let(:no_pegs_rating) { "Your guess received no pegs.\n" }

      it 'rates a guess with no similarites to the secret with 0 pegs' do
        guess = correct_guesses.sample.join('')
        allow(Renderer).to receive(:gets).and_return(guess)
        expect { game.rate_guess }.to output(no_pegs_rating).to_stdout
      end
    end
  end
end
