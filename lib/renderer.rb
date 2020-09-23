# frozen_string_literal: true

# Simple console IO-Wrapper
class Renderer
  
  def self.input(msg)
    print msg
    gets.chomp
  end

  def self.print(msg)
    puts msg
  end
end
