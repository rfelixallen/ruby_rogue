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
        # Move Left
        check1 = check_movement(window,character.xlines,character.ycols - 1,walkable,items,actors)
        check2 = check_movement(window,character.xlines,character.ycols + 1,walkable,items,actors)
        
        if character.ycols > player.ycols #&& (step1 == 32 or step1 == 126 or step1 == 64)
          if check1 == 1
            move_character_y(window,character,-1)
          elsif check1 == 2
            attack(player)
          else
            nil
          end
        end
=begin                    
          if (step1 == 32 or step1 == 126)
            character.ycols -= 1
          Ncurses.mvwaddstr(window, character.xlines, character.ycols + 1, " ")
          Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}")       
          else step1 == 64
          attack(player)
          Ncurses.mvwaddstr(hud, 4, 1, "HP: #{player.hp}")
          Ncurses.wrefresh(hud)
        end
#=end        
        #Ncurses.wrefresh(viewp)

      # Move Right        
      elsif character.ycols < player.ycols #&& (step2 == 32 or step2 == 126 or step2 == 64)
        if check2 == 1
            move_character_y(window,character,1)
          elsif check2 == 2
            attack(player)
          else
            nil
          end
        end
=begin        
        if (step2 == 32 or step2 == 126)
          character.ycols += 1
          Ncurses.mvwaddstr(window, character.xlines, character.ycols - 1, " ")
          Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}") 
        else step1 == 64
          attack(player)
          Ncurses.mvwaddstr(hud, 4, 1, "HP: #{player.hp}")
          Ncurses.wrefresh(hud)
        end
#=end        
        #Ncurses.wrefresh(viewp)

       # Stay Put
        else character.ycols == player.ycols
          # Move Up
          step3 = Ncurses.mvwinch(window,character.xlines - 1, character.ycols)
          step4 = Ncurses.mvwinch(window,character.xlines + 1, character.ycols)
          if character.xlines > player.xlines && (step3 == 32 or step3 == 126 or step3 == 64)
          if (step3 == 32 or step3 == 126)
            character.xlines -= 1
            Ncurses.mvwaddstr(window, character.xlines + 1, character.ycols, " ")
            Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}")
          else step3 == 64
            attack(player)
            Ncurses.mvwaddstr(hud, 4, 1, "HP: #{player.hp}")
            Ncurses.wrefresh(hud)
          end
          Ncurses.wrefresh(viewp)
          # Move Down
          else character.xlines < player.xlines && (step4 == 32 or step4 == 126 or step4 == 64)
          character.xlines += 1
          if (step4 == 32 or step4 == 126)
            Ncurses.mvwaddstr(window, character.xlines - 1, character.ycols, " ")
            Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}")
          else step4 == 64
            attack(player)
            Ncurses.mvwaddstr(hud, 4, 1, "HP: #{player.hp}")
            Ncurses.wrefresh(hud)
          end
          Ncurses.wrefresh(viewp)
        end
        end
    else  
        # Move Up
        step1 = Ncurses.mvwinch(window,character.xlines - 1, character.ycols)
        step2 = Ncurses.mvwinch(window,character.xlines + 1, character.ycols)
        if character.xlines > player.xlines && (step1 == 32 or step1 == 126 or step1 == 64)
        if (step1 == 32 or step1 == 126)
          character.xlines -= 1
          Ncurses.mvwaddstr(window, character.xlines + 1, character.ycols, " ")
          Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}")
        else step1 == 64
          attack(player)
          Ncurses.mvwaddstr(hud, 4, 1, "HP: #{player.hp}")
          Ncurses.wrefresh(hud)
        end
        Ncurses.wrefresh(viewp)
        # Move Down
        elsif character.xlines < player.xlines && (step2 == 32 or step2 == 126 or step2 == 64)
        character.xlines += 1
        if (step2 == 32 or step2 == 126)
          Ncurses.mvwaddstr(window, character.xlines - 1, character.ycols, " ")
          Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}")
        else step2 == 64
          attack(player)
          Ncurses.mvwaddstr(hud, 4, 1, "HP: #{player.hp}")
          Ncurses.wrefresh(hud)
        end
        Ncurses.wrefresh(viewp)
        else character.xlines == player.xlines 
          # Move Left
          step3 = Ncurses.mvwinch(window,character.xlines, character.ycols - 1)
          step4 = Ncurses.mvwinch(window,character.xlines, character.ycols + 1)
          if character.ycols > player.ycols && (step3 == 32 or step3 == 126 or step3 == 64)
            if (step3 == 32 or step3 == 126)
              character.ycols -= 1
            Ncurses.mvwaddstr(window, character.xlines, character.ycols + 1, " ")
            Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}")       
            else step3 == 64
              attack(player)
              Ncurses.mvwaddstr(hud, 4, 1, "HP: #{player.hp}")
              Ncurses.wrefresh(hud)
          end
          Ncurses.wrefresh(viewp)
        # Move Right        
        elsif character.ycols < player.ycols && (step4 == 32 or step4 == 126 or step4 == 64)
          if (step4 == 32 or step4 == 126)
              character.ycols += 1
              Ncurses.mvwaddstr(window, character.xlines, character.ycols - 1, " ")
              Ncurses.mvwaddstr(window, character.xlines, character.ycols, "#{character.symb}") 
          else step4 == 64
            attack(player)
          end
          Ncurses.wrefresh(viewp)
        end
      end   
    end
end
=end