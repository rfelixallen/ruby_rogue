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
  setpos((lines - 5) / 2, (cols - 10) / 2)
  refresh
  
  setpos((lines - 2) / 2, (cols - 8) / 2)  
  input = getch
  refresh
  getch

  setpos((lines - 2) / 2, (cols - 8) / 2)
  addstr("#{input}")
  refresh
  getch

  refresh
ensure
  close_screen
end
