# frozen_string_literal: true

require 'renderer_spy'

RSpec.describe RendererSpy do
  subject(:renderer) { described_class.new }

  describe '#display_invalid_guess ' do
    it 'displays an invalid guess message' do
      renderer.display_invalid_guess
      expect(renderer.displayed_msgs).to eq [described_class::INVALID_GUESS]
    end
  end

  describe '#display_correct_guess' do
    it 'displays an correct guess message' do
      renderer.display_correct_guess
      expect(renderer.displayed_msgs).to eq [described_class::CORRECT_GUESS]
    end
  end

  describe '#display_rating' do
    it 'displays the given rating of the players guess' do
      msg = 'Your guess received 0 black pegs.'
      renderer.display_rating(0, 'black')
      expect(renderer.displayed_msgs).to eq [msg]
    end
  end

  describe '#input_guess' do
    it 'displays the make a guess message and returns input' do
      allow(renderer).to receive(:gets).and_return('guess')
      expect(renderer.input_guess).to eq 'guess'
      expect(renderer.displayed_msgs).to eq [described_class::MAKE_GUESS]
    end
  end

  it '#display_board'
end
