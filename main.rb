require 'curses'
include Curses

# Game variables
main_char = '@'

init_screen

begin
  crmode
  
  setpos((lines - 5) / 2, (cols - 10) / 2)
  addstr("Hit any key")
  refresh
  getch

  #show_message("Hello, World!")

  setpos((lines - 5) / 2, (cols - 10) / 2)
  addstr("Welcome to RR. Press any key to start.")
  refresh
  getch

  clear
  setpos((lines - 5) / 2, (cols - 10) / 2)
  refresh
  getch
  
  setpos((lines - 5) / 2, (cols - 10) / 2)  
  input = "x"
  refresh
  getch

  clear

  x = 1
  while x == 1
  	if input == 'q'
  		setpos((lines - 5) / 2, (cols - 10) / 2)  
  		addstr("Goodbye!")
  		refresh
  		getch
  		break
  	else
  	setpos((lines - 5) / 2, (cols - 10) / 2)  
  	addstr("#{main_char}")
  	input = getch
  	refresh
  	getch
  	end
  end

  refresh
ensure
  close_screen
end
