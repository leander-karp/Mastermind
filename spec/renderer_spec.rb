# frozen_string_literal: true

require 'renderer_spy'

RSpec.describe Renderer do
  subject(:renderer) { RendererSpy.new }

  describe '#display_invalid_code ' do
    it 'displays an invalid guess message' do
      renderer.display_invalid_code
      expect(renderer.displayed_msgs).to eq [described_class::INVALID_CODE]
    end
  end

  describe '#display_rating' do
    it 'displays the given rating of the players guess' do
      msg = 'The guess received 0 black pegs.'
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

  describe '#display_guesses' do
    it 'displays that no guesses where made if there are no guesses' do
      expected_output = [Renderer::NO_GUESSES_EXIST]
      renderer.display_guesses
      expect(renderer.displayed_msgs).to eq expected_output
    end

    it 'displays all guesses made including an numeration' do
      guesses = %w[1111 2222]
      expected_output = [Renderer::GUESSES_EXIST]
      guesses.each_with_index do |guess, index|
        expected_output.push "#{index + 1}. #{guess}"
      end

      renderer.display_guesses guesses
      expect(renderer.displayed_msgs).to eq expected_output
    end
  end

  describe '#display_welcome_msg' do
    it 'displays a proper welcome message' do
      renderer.display_welcome_msg
      expect(renderer.displayed_msgs).to eq [described_class::WELCOME_MSG]
    end
  end
  describe '#choose_role' do
    it "equals 'y' if the player answers 'y'" do
      allow(renderer).to receive(:gets).and_return('y')
      expect(renderer.choose_role).to eq 'y'
      expect(renderer.displayed_msgs).to eq [Renderer::CODEBREAKER_QUESTION]
    end
  end
  describe '#select_secret' do
    it 'allows the player to select a secret' do
      allow(renderer).to receive(:gets).and_return('secret')
      expect(renderer.select_secret).to eq 'secret'
      expect(renderer.displayed_msgs).to eq [described_class::SELECT_SECRET_MSG]
    end
  end
end
