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
  input = getch
  refresh
  getch

  clear
  setpos((lines - 5) / 2, (cols - 10) / 2)
  refresh
  getch

  refresh
ensure
  close_screen
end
