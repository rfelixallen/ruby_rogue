def test_actors
	puts "Actors Loaded!"
end

class Character
  attr_accessor :symb, :px, :py, :hp
  def initialize(px, py)
    @symb = '@'
    @px = px    # Player X location
    @py = py    # Player Y location
    @hp = 10    # Default Hit Points
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