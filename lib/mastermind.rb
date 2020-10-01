# frozen_string_literal: true

require_relative 'renderer'

# The Mastermind class provides the interface to play a game of Master Mind
class Mastermind
  attr_reader :renderer

  SIZE = 4
  COLORS = (1..6).freeze
  MAX_ROUNDS = 12

  def initialize(renderer)
    @is_player_codebreaker = false
    @renderer = renderer
    @secret = generate_secret_code
    @current_guess = []
    @past_guesses = []
    @current_black_rating = 0
  end

  def start
    renderer.display_welcome_msg
    choose_role
    until @past_guesses.size >= MAX_ROUNDS || game_over?
      renderer.display_guesses @past_guesses
      make_player_guess
      rate_guess
      @past_guesses.push @current_guess
    end
  end

  def game_over?
    @current_black_rating == SIZE
  end

  def rate_guess
    occurences = color_occurences_in_guess
    @current_black_rating = 0
    white_pegs = 0

    @secret.each_index do |index|
      next if occurences[index].empty?

      if occurences[index].include?(index)
        @current_black_rating += 1
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

    renderer.display_rating(@current_black_rating, 'black')
    renderer.display_rating(white_pegs, 'white')
  end

  def make_player_guess
    @current_guess = renderer.input_guess

    until verify_guess(@current_guess)
      renderer.display_invalid_guess
      @current_guess = renderer.input_guess
    end
    @current_guess = @current_guess.split('').map(&:to_i)
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
      guess_indices_with_equal_color = @current_guess.each_index.select do |i|
        @current_guess[i] == color
      end
      accumulator.push guess_indices_with_equal_color
    end
  end
end
