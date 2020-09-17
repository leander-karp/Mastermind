# frozen_string_literal: true

require 'mastermind'

RSpec.describe Mastermind do
  context 'given an new game instance' do
    subject(:game) { described_class.new }
    
    describe '#start' do
      let(:player_role_question) {"Do you want to be the codebreaker?\n"}
      it 'asks the player whether he wants to be the codebreaker' do
        expect {game.start}.to output(player_role_question).to_stdout
      end
    end
  end
end
