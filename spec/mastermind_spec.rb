# frozen_string_literal: true

require 'mastermind'

RSpec.describe Mastermind do
  context 'given an new game instance' do
    subject(:game) { described_class.new }

    describe '#start' do
      let(:player_role_question) { /Do you want to be the codebreaker?/ }
      let(:first_guess) { /Please enter your first guess:/}
      let(:set_secret_code) { /Please set your secret code:/}

      context 'given the player does provide invalid input' do
        it 'asks the player whether he wants to be the codebreaker' do
          allow(game).to receive(:gets).and_return('invalid')
          expect { game.start}.to output(player_role_question).to_stdout
          expect { game.start}.not_to output(first_guess).to_stdout
          expect { game.start}.not_to output(set_secret_code).to_stdout 
        end
      end 
      
      context 'given that the player decides to play as codebreaker' do
        it 'asks the player to make the first guess' do
          allow(game).to receive(:gets).and_return('yes')
          expect { game.start}.not_to output(set_secret_code).to_stdout 
          expect { game.start}.to output(first_guess).to_stdout
        end
      end

      context 'given that the player decides to play as codemaker' do
        it 'asks the player to set the secret code' do
          allow(game).to receive(:gets).and_return('no')
          expect { game.start}.not_to output(first_guess).to_stdout
          expect { game.start}.to output(set_secret_code).to_stdout
        end
      end
    end
  end
end
