require_relative 'library'
require 'ncurses'
include Ncurses

##################################################################################
# TODO                                                                           #
#   *Refactor existing code, use header files                                    #
#   *Refactor character and monster class to be children of new Actor class      #
#   *Add Perlin Noise                                                            #
#   *Add item pickups                                                            #
#   *Add z-levels                                                                #
#   *Add color                                                                   #
##################################################################################
# Class & Methods                                                                #
##################################################################################
test_library
test_ui
test_terrain
test_actors

#################################################################################
# Initialize                                                                    #
#################################################################################

Ncurses.initscr             # Start Ncurses
Ncurses.noecho              # Do not show keyboard input at cursor location
Ncurses.curs_set(0)         # Disable blinking cursor
Ncurses.cbreak              # Only accept a single character of input
Ncurses.stdscr              # Initialize Standard Screen, which uses dimensions of current Terminal window
Ncurses.keypad(stdscr,true) # Use expanded keyboard characters

sd_cols = []                # Standard Screen column aka y
sd_lines = []               # Standard Screen lines aka x
Ncurses.getmaxyx(stdscr,sd_cols,sd_lines) # Get Max Y,X for standard screen, place them in arrays. getmaxyx outputs to arrays.

# Welcome Streen
Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2, sd_lines[0] / 2, "Welcome to Move!")
Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2 + 1, sd_lines[0] / 2, "rows = #{sd_cols[0]}, rows = #{sd_lines[0]}")
Ncurses.refresh             # Refresh window to display new text
Ncurses.getch               # Wait for user input
Ncurses.clear               # Clear the screen once player is ready to proceed
Ncurses.refresh             # Refresh window to display cleared screen

# Instantiate Windows
# For each window, define lines,cols variables and work with those instead of direct numbers
# Demo game uses 4 windows: Field (aka game map), Viewport (aka what the player sees), Console and side HUD.
field_lines = 100
field_cols = 100
view_lines = field_lines / 4
view_cols = field_cols / 4
hud_lines = view_lines
hud_cols = 15
console_lines = 3
console_cols = view_cols + hud_cols

field = Ncurses.newwin(field_lines, field_cols, 0, 0)
viewp = Ncurses.derwin(field,view_lines, view_cols, 0, 0) # Must not exceed size of terminal or else crash
console = Ncurses.newwin(console_lines, console_cols, view_lines, 0) 
hud = Ncurses.newwin(hud_lines, hud_cols, 0, view_lines) 

# Draw map
# Ncurses uses the ascii decimal value of characters for input
# Included are 3 different map generation methods. Only one should be used.
draw_map(field)         # Draws a simple map with one terrain type
#generate_random(field) # Draws a map with x random characters, randomly chosen for each pixel.
building(field,10,10)   # Adds a building to map. It overlays anything underneath it

# Define Actors, Items and Terrain
actors = []         # Array will contain ascii decimal value of actor symbols 
items = [36]        # Array contains ascii decimal value of all items on ground
walkable = [32,126] # Array contains ascii decimal value of all walkable terrain

# Setup Actors
field_max_lines = []
field_max_cols = []
Ncurses.getmaxyx(field,field_max_cols,field_max_lines)   # Get Max Y,X of Field
player_start_lines = (field_max_lines[0] / 4)
player_start_cols = (field_max_cols[0] / 4)

# Create Player Character
p = Character.new(player_start_cols, player_start_lines) # Begin player in top, right corner
actors << p.symb                                         # Add player symbol to array of actor symbols
Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")        # Draw layer to map
center(viewp,field,p.px,p.py)                            # Center map on player

# Create Monster
m = Monster.new(player_start_cols + 10, player_start_lines + 10) # Begin Monster near player
actors << m.symb                                                 # Add player symbol to array of actor symbols
Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")                # Draw Monster to map
Ncurses.wrefresh(viewp) # Update viewport with all previous changes

# Set up Console
borders(console)                            # Add borders to the console
Ncurses.mvwaddstr(console, 1, 2, "Hello!")  # Add a test message to confirm console works
Ncurses.wrefresh(console)                   # Refresh console window with message

# Set up HUD (Heads-Up-Display)
# Ideally, HUD will be updated automatically, and not by hand.
borders(hud)                                
Ncurses.mvwaddstr(hud, 1, 1, "The Game")
Ncurses.mvwaddstr(hud, 2, 1, "Time: 16:04")
Ncurses.mvwaddstr(hud, 3, 1, "Temp: 16 F")
Ncurses.mvwaddstr(hud, 4, 1, "HP: #{p.hp}")
Ncurses.mvwaddstr(hud, 5, 1, "Inventory:")
Ncurses.mvwaddstr(hud, 6, 1, "  -Club")
Ncurses.mvwaddstr(hud, 7, 1, "  -Flashlight")
Ncurses.wrefresh(hud)
#################################################################################
# Game Loop                                                                     #
#################################################################################

while p.hp > 0  # While Player hit points are above 0, keep playing
=begin  
  # Resize window to the terminal screen
  new_y = []
  new_x = []
  Ncurses.getmaxyx(stdscr,new_y,new_x)

  if (new_y != parent_y || new_x != parent_x)
    Ncurses.wclear(viewp)

    sd_lines[0] = new_x[0]
    sd_cols[0] = new_y[0]

    ######viewp.resize(new_y, new_x) # Resizes window to terminal screen
    borders(viewp) # Redraw new borders
    simple_generate(field) # Put snow back on map
    Ncurses.wrefresh(viewp)
    Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
    Ncurses.wrefresh(field)
  end
=end
  input = Ncurses.getch
  case input
    when KEY_UP, 119 # Move Up
      step = Ncurses.mvwinch(field,p.px - 1, p.py)
      message(console,step)
      if p.px > 1 && (walkable.include?(step) or items.include?(step) or step == 77)
      if walkable.include?(step)
        p.px -= 1
        Ncurses.mvwaddstr(field, p.px + 1, p.py, " ")
        Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
      elsif step == 77 
        m.hp -= 1
      else items.include?(step)
        Ncurses.mvwaddstr(hud, 8, 1, "  -Money")
        Ncurses.wrefresh(hud)
        p.px -= 1
        Ncurses.mvwaddstr(field, p.px + 1, p.py, " ")
        Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
        end
      end
      center(viewp,field,p.px,p.py)
      Ncurses.wrefresh(viewp)
    when KEY_DOWN, 115 # Move Down
      step = Ncurses.mvwinch(field,p.px + 1, p.py)
      message(console,step)
      if p.px < (field_max_cols[0] - 2) && (step == 32 or step == 126 or step == 77)
      if (step == 32 or step == 126)
        p.px += 1 
        Ncurses.mvwaddstr(field, p.px - 1, p.py, " ")
        Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
      else step == 77
        m.hp -= 1
        end
      end
      center(viewp,field,p.px,p.py)
      Ncurses.wrefresh(viewp)
    when KEY_RIGHT, 100 # Move Right
      step = Ncurses.mvwinch(field,p.px, p.py + 1)
      message(console,step)
      if p.py < (field_max_lines[0] - 2) && (step == 32 or step == 126 or step == 77)
      if (step == 32 or step == 126)
        p.py += 1 
        Ncurses.mvwaddstr(field, p.px, p.py - 1, " ")
        Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
      else step == 77
        m.hp -= 1       
        end
      end
      center(viewp,field,p.px,p.py)
      Ncurses.wrefresh(viewp)
  when KEY_LEFT, 97 # Move Left
    step = Ncurses.mvwinch(field,p.px, p.py - 1)
      message(console,step)
      if p.py > 1 && (step == 32 or step == 126 or step == 77)
      if (step == 32 or step == 126)
        p.py -= 1 
        Ncurses.mvwaddstr(field, p.px, p.py + 1, " ")
        Ncurses.mvwaddstr(field, p.px, p.py, "#{p.symb}")
      else step == 77
        m.hp -= 1
        end
      end
      center(viewp,field,p.px,p.py)
      Ncurses.wrefresh(viewp)
    when KEY_F2, 113, 81 # Quit Game with F2, q or Q
      break
    else
      Ncurses.flash           # Flash screen if undefined input selected
      message(console,input)  # Display ascii decimal number of selected input
      Ncurses.wrefresh(console) 
    end

    # Monster Move (Chasing Mode)
    if m.hp <= 0
    Ncurses.mvwaddstr(field, m.mx, m.my, "X")
    Ncurses.wrefresh(viewp)
  else
      flip1 = rand(2)
      if flip1 == 0
        # Move Left
        step1 = Ncurses.mvwinch(field,m.mx, m.my - 1)
        step2 = Ncurses.mvwinch(field,m.mx, m.my + 1)
        if m.my > p.py && (step1 == 32 or step1 == 126 or step1 == 64)
          if (step1 == 32 or step1 == 126)
            m.my -= 1
          Ncurses.mvwaddstr(field, m.mx, m.my + 1, " ")
          Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")       
          else step1 == 64
          p.hp -= 1
        end
        Ncurses.wrefresh(viewp)
      # Move Right        
      elsif m.my < p.py && (step2 == 32 or step2 == 126 or step2 == 64)
          if (step2 == 32 or step2 == 126)
            m.my += 1
            Ncurses.mvwaddstr(field, m.mx, m.my - 1, " ")
            Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}") 
        else step1 == 64
          p.hp -= 1
        end
        Ncurses.wrefresh(viewp)
       # Stay Put
        else m.my == p.py
          # Move Up
          step3 = Ncurses.mvwinch(field,m.mx - 1, m.my)
          step4 = Ncurses.mvwinch(field,m.mx + 1, m.my)
          if m.mx > p.px && (step3 == 32 or step3 == 126 or step3 == 64)
          if (step3 == 32 or step3 == 126)
            m.mx -= 1
            Ncurses.mvwaddstr(field, m.mx + 1, m.my, " ")
            Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
          else step3 == 64
            p.hp -= 1
          end
          Ncurses.wrefresh(viewp)
          # Move Down
          else m.mx < p.px && (step4 == 32 or step4 == 126 or step4 == 64)
          m.mx += 1
          if (step4 == 32 or step4 == 126)
            Ncurses.mvwaddstr(field, m.mx - 1, m.my, " ")
            Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
          else step4 == 64
            p.hp -= 1
          end
          Ncurses.wrefresh(viewp)
        end
        end
    else  
        # Move Up
        step1 = Ncurses.mvwinch(field,m.mx - 1, m.my)
        step2 = Ncurses.mvwinch(field,m.mx + 1, m.my)
        if m.mx > p.px && (step1 == 32 or step1 == 126 or step1 == 64)
        if (step1 == 32 or step1 == 126)
          m.mx -= 1
          Ncurses.mvwaddstr(field, m.mx + 1, m.my, " ")
          Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
        else step1 == 64
          p.hp -= 1
        end
        Ncurses.wrefresh(viewp)
        # Move Down
        elsif m.mx < p.px && (step2 == 32 or step2 == 126 or step2 == 64)
        m.mx += 1
        if (step2 == 32 or step2 == 126)
          Ncurses.mvwaddstr(field, m.mx - 1, m.my, " ")
          Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")
        else step2 == 64
          p.hp -= 1
        end
        Ncurses.wrefresh(viewp)
        else m.mx == p.px 
          # Move Left
          step3 = Ncurses.mvwinch(field,m.mx, m.my - 1)
          step4 = Ncurses.mvwinch(field,m.mx, m.my + 1)
          if m.my > p.py && (step3 == 32 or step3 == 126 or step3 == 64)
            if (step3 == 32 or step3 == 126)
              m.my -= 1
            Ncurses.mvwaddstr(field, m.mx, m.my + 1, " ")
            Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}")       
            else step3 == 64
            p.hp -= 1
          end
          Ncurses.wrefresh(viewp)
        # Move Right        
        elsif m.my < p.py && (step4 == 32 or step4 == 126 or step4 == 64)
            if (step4 == 32 or step4 == 126)
              m.my += 1
              Ncurses.mvwaddstr(field, m.mx, m.my - 1, " ")
              Ncurses.mvwaddstr(field, m.mx, m.my, "#{m.symb}") 
          else step4 == 64
            p.hp -= 1
          end
          Ncurses.wrefresh(viewp)
        end
      end   
      end
  end
end
Ncurses.clear
Ncurses.mvwaddstr(stdscr, sd_cols[0] / 2, sd_lines[0] / 2, "Good Bye!")
Ncurses.wrefresh(stdscr)
Ncurses.getch
Ncurses.endwin