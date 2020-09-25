# frozen_string_literal: true

require_relative 'renderer'

# The Mastermind class provides the interface to play a game of Master Mind
class Mastermind
  attr_reader :renderer

  SIZE = 4
  COLORS = (1..6).freeze

  def initialize(renderer)
    @renderer = renderer
    @secret = generate_secret_code
    @current_guess = []
  end

  def rate_guess
    pegs_per_color = count_secret_color_occurences
    black_pegs = 0
    white_pegs = 0
    @current_guess.each_with_index do |current_color, index|
      next if (pegs_per_color[current_color]).zero?

      if current_color == @secret[index]
        black_pegs += 1
      elsif @secret.include?(current_color)
        white_pegs += 1
      end
      pegs_per_color[current_color] -= 1
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

  def count_secret_color_occurences
    pegs_per_color = {}
    COLORS.each do |color|
      pegs_per_color[color] = @secret.count(color)
    end
    pegs_per_color
  end
end
