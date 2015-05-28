require 'ncurses'
include Ncurses

class Cobject
	attr_accessor :symb, :number, :color
	  def initialize(options = {})
	    self.symb = options[:symb] || '@'
	    self.number = options[:number]
	    self.color = options[:color]
	  end
end

Ncurses.initscr
Ncurses.start_color
Ncurses.init_pair(1,COLOR_BLACK,COLOR_RED)
Ncurses.init_pair(2,COLOR_BLUE,COLOR_GREEN)

Ncurses.mvaddstr(0,0,"Hello World!\n")
Ncurses.attrset(Ncurses.COLOR_PAIR(1));
Ncurses.addstr("My name is Mr. Black!\n");
Ncurses.attrset(Ncurses.COLOR_PAIR(2));
Ncurses.addstr("My name is Mr. Blue!\n");

Ncurses.refresh
Ncurses.getch
Ncurses.clear
Ncurses.endwin