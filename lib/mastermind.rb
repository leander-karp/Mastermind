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
    @secret = generate_code
    @current_guess = []
    @past_guesses = []
    @current_black_rating = 0
  end

  def start
    renderer.display_welcome_msg
    choose_role

    @secret = player_select_secret unless player_codebreaker?

    until @past_guesses.size >= MAX_ROUNDS || game_over?
      renderer.display_guesses @past_guesses
      if player_codebreaker?
        make_player_guess
      else
        computer_guess
      end
      rate_guess
      @past_guesses.push @current_guess
    end
  end

  def game_over?
    @current_black_rating == SIZE
  end

  def rate_guess
    @current_black_rating = 0
    white_pegs = 0
    used_secret_indices = []
    used_guess_indices = []

    all_indices_of lambda { |element_to_find, array|
      array.each_index.select { |index| array[index] == element_to_find }
    }

    @secret.each_with_index do |secret_color, secret_index|
      next unless secret_color == @current_guess[secret_index]

      @current_black_rating += 1
      used_secret_indices.push secret_index
      used_guess_indices.push  secret_index
    end

    @current_guess.each_with_index do |guess_color, guess_index|
      next if used_guess_indices.include?(guess_index)

      indices = all_indices_of(guess_color, @secret)
      delta = indices.difference(used_secret_indices)

      next unless @secret.include?(guess_color) && !delta.empty?

      white_pegs += 1
      used_secret_indices.push delta.pop
      used_guess_indices.push  guess_index
    end

    renderer.display_rating(@current_black_rating, 'black')
    renderer.display_rating(white_pegs, 'white')
  end

  def make_player_guess
    @current_guess = renderer.input_guess

    until verify_code(@current_guess)
      renderer.display_invalid_code
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

  def verify_code(guess)
    return false if guess.size != SIZE

    guess.split('').map do |char|
      COLORS.include?(char.to_i)
    end.all?
  end

  def generate_code
    generator = Random.new
    Array.new(SIZE) { generator.rand(COLORS.max) + 1 }
  end

  def player_select_secret
    secret = renderer.select_secret
    until verify_code(secret)
      renderer.display_invalid_code
      secret = renderer.select_secret
    end
    secret.split('').map(&:to_i)
  end

  def computer_guess
    guess = generate_code
    guess = generate_code while @past_guesses.include? guess
    renderer.display_computer_guess guess.join('')
    @current_guess = guess
  end
end
