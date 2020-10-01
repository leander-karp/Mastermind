# frozen_string_literal: true

require_relative 'renderer'

# The Mastermind class provides the interface to play a game of Master Mind
class Mastermind
  attr_reader :renderer

  SIZE = 4
  COLORS = (1..6).freeze

  def initialize(renderer)
    @is_player_codebreaker = false
    @renderer = renderer
    @secret = generate_secret_code
    @current_guess = []
  end

  def rate_guess
    occurences = color_occurences_in_guess
    black_pegs = 0
    white_pegs = 0

    @secret.each_index do |index|
      next if occurences[index].empty?

      if occurences[index].include?(index)
        black_pegs += 1
      else
        index_to_remove = occurences[index].reject { |i| occurences[i].include?(i) }.sample
        unless index_to_remove.nil?
          white_pegs += 1
          occurences.each_index do |i|
            occurences[i].delete(index_to_remove)
          end
        end
      end
    end

    renderer.display_rating(black_pegs, 'black')
    renderer.display_rating(white_pegs, 'white')
  end

  def make_player_guess
    @current_guess = renderer.input_guess

    until verify_guess(@current_guess)
      renderer.display_invalid_guess
      @current_guess = renderer.input_guess
    end
    @current_guess = @current_guess.split('').map(&:to_i)
    renderer.display_correct_guess
  end

  def choose_role
    decision = renderer.choose_role
    decision = renderer.choose_role until %w[y n].include?(decision)
    @is_player_codebreaker = (decision == 'y')
  end

  def player_codebreaker?
    @is_player_codebreaker
  end

  private

  def verify_guess(guess)
    return false if guess.size != SIZE

    guess.split('').map do |char|
      COLORS.include?(char.to_i)
    end.all?
  end

  def generate_secret_code
    generator = Random.new
    Array.new(SIZE) { generator.rand(6) + 1 }
  end

  def color_occurences_in_guess
    @secret.each_with_object([]) do |color, accumulator|
      accumulator.push(@current_guess.each_index.select do |i|
        @current_guess[i] == color
      end)
    end
  end
end
