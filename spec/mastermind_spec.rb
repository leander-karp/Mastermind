# frozen_string_literal: true

require 'mastermind'

def generate_guesses(range)
  colors = range.to_a * 4
  colors.combination(4).to_a
end

def generate_invalid_guesses(range)
  generate_guesses(range).select { |guess| guess.include?(0) }
end

RSpec.describe Mastermind do
  subject(:game) { described_class.new }

  context 'player is codebreaker' do
    describe '#start' do
      let(:next_guess_msg) { "Please enter your next guess:\n"}
      let(:correct_guess_msg) {"Correct guess\n"}
      let(:invalid_guess_msg) {"Invalid guess\n"}

      it 'asks for guesses until a correct guess is provided' do
        expected_output = next_guess_msg + invalid_guess_msg + \
          next_guess_msg + correct_guess_msg
                  
        correct_guesses = generate_guesses(1..6)
        invalid_guesses = generate_invalid_guesses(0..6)

        invalid_guesses.each do |invalid_guess|
          correct_guess = correct_guesses.sample.join('')
          allow(game).to receive(:gets).and_return( invalid_guess.join(''), 
            correct_guess)
          
          expect {game.start}.to output(expected_output).to_stdout
        end
      end

      it 'displays all guesses made' do 

      end 
    end


  end
end
