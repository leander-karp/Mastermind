# frozen_string_literal: true

require_relative 'lib/mastermind'
require_relative 'lib/renderer'

mastermind = Mastermind.new(Renderer.new)
mastermind.make_player_guess
