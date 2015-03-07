require 'curses'
include Curses

def center_message(message)
  setpos((lines - 5) / 2, (cols - 10) / 2)
  addstr("#{message}")
  refresh
  getch
  clear
end

# Game variables
main_char = '@'

init_screen

begin
  crmode

  #show_message("Hello, World!")

  setpos((lines - 5) / 2, (cols - 10) / 2)
  addstr("Welcome to RR. Press any key to start.")
  refresh
  getch
  noecho


=begin
  clear
  setpos((lines - 5) / 2, (cols - 10) / 2)
  refresh
  getch

  setpos((lines - 5) / 2, (cols - 10) / 2)  
  input = "x"
  refresh
  getch
=end

  while input = getch
    center_message("Test.")
    setpos((lines - 5) / 2, (cols - 10) / 2)  
    addstr("#{main_char}")
    case input
    when "q"
      clear
      center_message("Goodbye!")
      refresh
      getch
      break
    when "h"
    else
    end
  end

  refresh
ensure
  close_screen
end
