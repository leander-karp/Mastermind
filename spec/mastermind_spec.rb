# frozen_string_literal: true

require 'mastermind'

RSpec.describe Mastermind do
  subject(:game) { described_class.new }

  context 'player is codebreaker' do
    describe '#start' do
      let(:next_guess) { /Please enter your next guess:/}
      let(:correct_guess) {"\nCorrect guess\n"}
      let(:incorrect_guess) {"\nIncorrect guess\n"}
      let(:correct_guesses) {1111..6666}

      it 'promts the player to guess' do
        allow(game).to receive(:gets).and_return('1111')
        expect {game.start}.to output(next_guess).to_stdout
      end

      it 'gets an guess from the player' do 
        allow(game).to receive(:gets).and_return('1111', 'abcd')
        next_guess_msg = next_guess.source
        expect {game.start}.to output(next_guess_msg + correct_guess).to_stdout
        expect {game.start}.to output(next_guess_msg + incorrect_guess).to_stdout
      end 
    end
  end
end
