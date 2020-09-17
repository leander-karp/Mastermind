# frozen_string_literal: true

require 'mastermind'

RSpec.describe Mastermind do
  subject(:game) { described_class.new }

  context 'player is codebreaker' do
    describe '#start' do
      let(:next_guess) { /Please enter your next guess:/}
      let(:correct_guess) {"\nCorrect guess\n"}
      let(:incorrect_guess) {"\nIncorrect guess\n"}
      let(:correct_guesses) {(1111..6666).to_a}

      it 'promts the player to guess' do
        allow(game).to receive(:gets).and_return('1111')
        expect {game.start}.to output(next_guess).to_stdout
      end

      it 'gets an guess from the player' do 
        random_guess = correct_guesses.sample.to_s
        next_guess_msg = next_guess.source

        allow(game).to receive(:gets).and_return(random_guess, 'abcd')

        expect {game.start}.to output(next_guess_msg + correct_guess).to_stdout
        expect {game.start}.to output(next_guess_msg + incorrect_guess).to_stdout
      end 

      it 'asks for guesses until an valid guess is provided' do 
        
      end 
    end
  end
end
