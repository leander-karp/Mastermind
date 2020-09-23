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
  subject(:renderer_class) { renderer.class }
  subject(:game) { described_class.new(renderer) }
  let(:invalid_codes) { generate_invalid_codes(1..6) }
  let(:correct_codes) { generate_codes(1..6) }

  context 'player is codebreaker' do
    describe '#make_player_guess' do
      it 'asks for guesses until a correct guess is provided' do
        expected_output = [renderer_class::MAKE_GUESS,
                           renderer_class::INVALID_GUESS,
                           renderer_class::MAKE_GUESS,
                           renderer_class::CORRECT_GUESS]

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
      it 'rates a guess with no similarites to the secret with 0 pegs' do
        expected_output = ['Your guess received 0 black pegs.',
                           'Your guess received 0 white pegs.']
        correct_codes_copy = correct_codes.clone
        correct_codes_copy.delete game.secret
        guess = correct_codes_copy.sample.join('')
        allow(renderer).to receive(:gets).and_return(guess)

        game.rate_guess
        expect(renderer.displayed_msgs).to eq expected_output
      end

      it 'gives 4 white pegs if all colors are present in the guess' 
      it 'gives 4 black pegs if the secret equals the guess'
      
      context 'the secrect contains duplicate colors' do 
        it 'rewards only the correct number of duplicate colors in the guess'

      end 
    end
  
    describe '#generate_secret' do 
      let(:seed) {10}

      it 'uses random values to generate valid secrets' do 
        generator = Random.new(seed)
        fake_random = Random.new(seed)

        for i in 0...10
          expect(Random).to receive(:new).and_return(fake_random)
          new_game = described_class.new(nil)

          expected_secret = Array.new(4) {generator.rand(6)+1}
          expect(new_game.secret).to eq expected_secret
          expect(correct_codes.include?(new_game.secret)).to be true
        end
      end 
    end 
    
  end
end
