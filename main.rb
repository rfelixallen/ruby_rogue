require 'curses'
include Curses

def center_message(message)
  viewport.setpos((lines - 5) / 2, (cols - 10) / 2)
  viewport.addstr("#{message}")
  viewport.refresh
  viewport.getch
  clear
end

# Game variables
main_char = '@'

init_screen

world = Window.new(100, 100, 100, 100)
world.box("|", "-")
viewport = subwin(world,5, 5, (lines - 5) / 2, (cols - 10) / 2)

viewport.refresh
viewport.getch


begin
  crmode

  #show_message("Hello, World!")

  viewport.setpos((lines - 5) / 2, (cols - 10) / 2)
  viewport.addstr("Welcome to RR. Press any key to start.")
  viewport.refresh
  viewport.getch

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
