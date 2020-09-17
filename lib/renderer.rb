class Renderer
  def self.print(msg)
    puts msg 
  end 

  def self.read(msg, possiblities)
    self.print(msg)
    gets.chomp
  end
end