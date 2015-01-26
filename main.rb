require 'curses'
include Curses

init_screen

begin
  crmode
  setpos((lines - 5) / 2, (cols - 10) / 2)
  addstr("Hit any key")
  refresh
  getch
  refresh
ensure
  close_screen
end
