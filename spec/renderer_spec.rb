# frozen_string_literal: true

require 'renderer_spy'

RSpec.describe Renderer do
  subject(:renderer) { RendererSpy.new }

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
end
