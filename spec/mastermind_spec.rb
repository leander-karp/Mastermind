# frozen_string_literal: true

require 'mastermind'

RSpec.describe Mastermind do
  context 'given an new game instance' do
    subject(:game) { described_class.new }

    describe '#start' do
      it 'asks the player whether he wants to be the codebreaker' do
        game.start
      end
    end
  end
end
