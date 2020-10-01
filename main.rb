# frozen_string_literal: true

require_relative 'lib/mastermind'
require_relative 'lib/renderer'

Mastermind.new(Renderer.new).start
