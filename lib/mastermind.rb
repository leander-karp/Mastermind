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
    occurences = color_occurences_in_guess
    # secrect index: [indices in guess having the secret color]
    
    @current_black_rating = 0
    white_pegs = 0

    @secret.each_index do |index|
      # continue if the secrect color is not present in the guess
      next if occurences[index].empty?
      

      if occurences[index].include?(index)
        # the secret color is at the right position in the guess 
        # => a black peg is added to the rating
        @current_black_rating += 1
      else
        # check if white pegs can be addet to the rating

        # select all indices from occurences[index] which do not match an index
        # in occurences
        index_to_remove = occurences[index].reject { |i| occurences[i].include?(i) }.sample
        unless index_to_remove.nil?
          white_pegs += 1
          # remove the used index from everywhere
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

  def color_occurences_in_guess
    @secret.each_with_object([]) do |color, accumulator|
      guess_indices_with_equal_color = @current_guess.each_index.select do |i|
        @current_guess[i] == color
      end
      accumulator.push guess_indices_with_equal_color
    end
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
