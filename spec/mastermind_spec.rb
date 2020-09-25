# frozen_string_literal: true

require 'mastermind'
require 'renderer_spy'

class MastermindSpy < Mastermind
  attr_accessor :secret
end

def generate_codes(range)
  colors = range.to_a * 4
  colors.combination(4).to_a
end

def generate_invalid_codes(range)
  invalid_codes = Set.new(generate_codes(0..9)) -
                  Set.new(generate_codes(range))
  invalid_codes.add(('6' * 5).split(''))
  invalid_codes
end

RSpec.describe MastermindSpy do
  subject(:renderer) { RendererSpy.new }
  subject(:game) { described_class.new(renderer) }
  let(:invalid_codes) { generate_invalid_codes(1..6) }
  let(:correct_codes) { generate_codes(1..6) }

  after(:each) do
    renderer.displayed_msgs.clear
  end

  context 'player is codebreaker' do
    describe '#make_player_guess' do
      it 'asks for guesses until a correct guess is provided' do
        expected_output = [Renderer::MAKE_GUESS,
                           Renderer::INVALID_GUESS,
                           Renderer::MAKE_GUESS,
                           Renderer::CORRECT_GUESS]

        invalid_codes.each do |invalid_guess|
          correct_guess = correct_codes.sample.join('')
          allow(renderer).to receive(:gets).and_return(invalid_guess.join(''),
                                                       correct_guess)
          renderer.displayed_msgs.clear

          game.make_player_guess
          expect(renderer.displayed_msgs).to eq expected_output
        end
      end
    end

    describe '#rate_guess' do
      it 'awards 0 pegs if no guess was made' do
        expected_output = [format(Renderer::RATING, 0, 'black'),
                           format(Renderer::RATING, 0, 'white')]
        game.rate_guess
        expect(renderer.displayed_msgs[-2, 2]).to eq expected_output
      end

      it 'awards a maximum of one peg per guess slot' do
        game.secret = [1, 1, 2, 2]
        allow(renderer).to receive(:gets).and_return('1112')
        expected_output = [format(Renderer::RATING, 3, 'black'),
                           format(Renderer::RATING, 0, 'white')]
        game.make_player_guess
        game.rate_guess
        expect(renderer.displayed_msgs[-2, 2]).to eq expected_output
      end

      it 'awards no white pegs if the peg is in the right position' do
        game.secret = [1, 1, 2, 2]
        allow(renderer).to receive(:gets).and_return('3112')
        expected_output = [format(Renderer::RATING, 2, 'black'),
                           format(Renderer::RATING, 1, 'white')]
        game.make_player_guess
        game.rate_guess
        expect(renderer.displayed_msgs[-2, 2]).to eq expected_output
      end

      context 'if the secret is 1234' do
        before(:each) do
          game.secret = [1, 2, 3, 4]
        end

        it 'awards 1 black peg if the guess has one correct color at the correct position' do
          correct_guesses = [[1, 6, 6, 6], [6, 2, 6, 6], [6, 6, 3, 6], [6, 6, 6, 4]]
          expected_output = 'Your guess received 1 black pegs.'
          correct_guesses.each do |guess|
            allow(renderer).to receive(:gets).and_return(guess.join(''))
            game.make_player_guess
            game.rate_guess
            expect(renderer.displayed_msgs[-2]).to eq expected_output
          end
        end

        it 'awards 2 black pegs if the guess has two correct colors at the correct positions' do
          correct_guesses = [[1, 2, 6, 6], [1, 6, 3, 6], [1, 6, 6, 4], [6, 2, 3, 6],
                             [6, 2, 6, 4], [6, 6, 3, 4]]
          expected_output = 'Your guess received 2 black pegs.'
          correct_guesses.each do |guess|
            allow(renderer).to receive(:gets).and_return(guess.join(''))
            game.make_player_guess
            game.rate_guess
            expect(renderer.displayed_msgs[-2]).to eq expected_output
          end
        end

        it 'awards 3 black pegs if the guess has three correct colors at the correct positions' do
          correct_guesses = [[1, 2, 3, 6], [1, 2, 6, 4], [1, 6, 3, 4], [6, 2, 3, 4]]
          expected_output = 'Your guess received 3 black pegs.'
          correct_guesses.each do |guess|
            allow(renderer).to receive(:gets).and_return(guess.join(''))
            game.make_player_guess
            game.rate_guess
            expect(renderer.displayed_msgs[-2]).to eq expected_output
          end
        end

        it 'awards 4 black pegs if the guess equals the secret' do
          expected_output = 'Your guess received 4 black pegs.'
          allow(renderer).to receive(:gets).and_return('1234')
          game.make_player_guess
          game.rate_guess
          expect(renderer.displayed_msgs[-2]).to eq expected_output
        end

        it 'awards 1 white peg if one color is correct, but not at the right position' do
          expected_output = 'Your guess received 1 white pegs.'
          allow(renderer).to receive(:gets).and_return('6661')
          game.make_player_guess
          game.rate_guess
          expect(renderer.displayed_msgs[-1]).to eq expected_output
        end

        it 'awards 4 white pegs if all secret colors are present' do
          expected_output = 'Your guess received 4 white pegs.'
          allow(renderer).to receive(:gets).and_return('4321')
          game.make_player_guess
          game.rate_guess
          expect(renderer.displayed_msgs[-1]).to eq expected_output
        end
      end
    end

    describe '#secret' do
      let(:seed) { 10 }

      it 'uses random values to generate valid secrets' do
        generator = Random.new(seed)
        fake_random = Random.new(seed)

        (0...10).each do |_i|
          allow(Random).to receive(:new).and_return(fake_random)
          new_game = described_class.new(nil)

          expected_secret = Array.new(4) { generator.rand(6) + 1 }
          expect(new_game.secret).to eq expected_secret
          expect(correct_codes.include?(new_game.secret)).to be true
        end
      end
    end
  end
end
