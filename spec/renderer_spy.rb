# frozen_string_literal: true

require 'renderer'

class RendererSpy < Renderer
  attr_reader :displayed_msgs

  def initialize
    @displayed_msgs = []
    super
  end

  def display(msg)
    displayed_msgs.push msg
  end

  def occurences(msg)
    displayed_msgs.count msg
  end
end
