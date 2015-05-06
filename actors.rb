class Character
  attr_accessor :symb, :xlines, :ycols, :hp
  def initialize(options = {})
    self.symb = options[:symb] || '@'
    self.xlines = options[:xlines] || 2
    self.ycols = options[:ycols] || 2
    self.hp = options[:hp] || 3
  end
end

def test_actors
  puts "Actors Loaded!"
end

def check_movement(window,xlines,ycols,walkable,items,actors)
    window_max_lines = []
    window_max_cols = []
    Ncurses.getmaxyx(window,window_max_cols,window_max_lines)   # Get Max Y,X of window
    
    step = Ncurses.mvwinch(window, xlines, ycols)
    if (xlines > 0 and ycols > 0 and xlines < (window_max_lines[0] - 1) and ycols < (window_max_cols[0] - 1))
      if walkable.include?(step) 
        return 1
      elsif actors.include?(step)
        return 2
      elsif items.include?(step)
        return 3
      else
        return false
      end
    else
      return false
    end
end

def move_character_x(window,character,i)
    character.xlines += i
    Ncurses.mvwaddstr(window, character.xlines + -i, character.ycols, " ")
    Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}")
end

def move_character_y(window,character,i)
    character.ycols += i
    Ncurses.mvwaddstr(window, character.xlines, character.ycols + -i, " ")
    Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}")
end

def attack(x)
    x.hp -= 1
end
=begin
# This mode causes the character to hunt the player.
def mode_hunt(window, character, player, walkable, items, actors))
  flip1 = rand(2)
      if flip1 == 0        
        check1 = check_movement(window,character.xlines,character.ycols - 1,walkable,items,actors)
        check2 = check_movement(window,character.xlines,character.ycols + 1,walkable,items,actors)
        
        # Move Left
        if character.ycols > player.ycols  
          if check1 == 1
            move_character_y(window,character,-1)
          elsif check1 == 2
            attack(player)
          else
            nil
          end
        end        

        # Move Right        
      elsif character.ycols < player.ycols
        if check2 == 1
            move_character_y(window,character,1)
          elsif check2 == 2
            attack(player)
          else
            nil
          end
        end        

       # Stay Put
      else character.ycols == player.ycols
          # Move Up          
          check3 = check_movement(window,character.xlines - 1,character.ycols,walkable,items,actors)
          check4 = check_movement(window,character.xlines + 1,character.ycols,walkable,items,actors)
          if character.xlines > player.xlines 
            if check3 == 1
              move_character_x(window,character,-1)
            elsif check3 == 2
              attack(player)
            else
              nil
            end                    
          # Move Down
          else character.xlines < player.xlines
            if check4 == 1
              move_character_x(window,character,1)
            elsif check4 == 2
              attack(player)
            else
              nil
            end          
          end        
    else  
        # Move Up
        check1 = check_movement(window,character.xlines - 1,character.ycols,walkable,items,actors)
        check2 = check_movement(window,character.xlines + 1,character.ycols,walkable,items,actors)        
        if character.xlines > player.xlines
            if check1 == 1
              move_character_x(window,character,-1)
            elsif check1 == 2
              attack(player)
            else
              nil
            end
          end
        # Move Down
        elsif character.xlines < player.xlines
            if check2 == 1
              move_character_x(window,character,1)
            elsif check2 == 2
              attack(player)
            else
              nil
            end
        else character.xlines == player.xlines 
          # Move Left
          check3 = check_movement(window,character.xlines,character.ycols - 1,walkable,items,actors)
          check4 = check_movement(window,character.xlines,character.ycols + 1,walkable,items,actors)
          if character.ycols > player.ycols
            if check3 == 1
              move_character_y(window,character,-1)
            elsif check3 == 2
              attack(player)
            else
              nil
            end
          end 
        # Move Right        
        elsif character.ycols < player.ycols
          if check4 == 1
            move_character_y(window,character,1)
          elsif check4 == 2
            attack(player)
          else
            nil
          end
        end
      end   
    end
end
=end