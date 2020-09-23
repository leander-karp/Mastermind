# frozen_string_literal: true

require 'renderer'

class RendererSpy < Renderer
  def initialize
    @displayed_msgs = []
    super
  end

  def display(msg)
    @displayed_msgs.push(msg)
  end

  attr_reader :displayed_msgs
end
