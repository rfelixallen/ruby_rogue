def test_actors
	puts "Actors Loaded!"
end

class Character
  attr_accessor :symb, :xlines, :ycols, :hp
  def initialize(options = {})
    self.symb = options[:symb] || '@'
    self.xlines = options[:xlines] || 2
    self.ycols = options[:ycols] || 2
    self.hp = options[:hp] || 3
  end
end