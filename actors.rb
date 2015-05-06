def test_actors
	puts "Actors Loaded!"
end
=begin
class Character
  attr_accessor :symb, :xlines, :ycols, :hp
  def initialize(symb, xlines, ycols)
    @symb = symb
    @xlines = xlines    # Player X location
    @ycols = ycols    # Player Y location
    @hp = 10    # Default Hit Points
  end
end
=end
class Character
  attr_accessor :symb, :xlines, :ycols, :hp
  def initialize(options = {})
    self.symb = options[:symb] || '@'
    self.xlines = options[:xlines] || 2
    self.ycols = options[:ycols] || 2
    self.hp = options[:hp] || 3
  end
end

class Monster
  attr_accessor :symb, :mx, :my, :hp
  def initialize(mx, my)
    @symb = 'M'
    @mx = mx 
    @my = my
    @hp = 3
  end
end