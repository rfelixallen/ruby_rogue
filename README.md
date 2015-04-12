ruby_rogue
==========

The purpose of this repo is to recreate a roguelike tutorial in Ruby. See original tutorial: https://solarianprogrammer.com/2012/07/12/roguelike-game-cpp-11-part-0/

TODOS
*Add in basic enemies
*Add in impassible terrain
*Update Keyboard commands to include both arrows and WASD
*Create Game Menu
*Incorporate Save/Load feature

Files:
main.rb - This will eventually be the main program. It will link all other files to itself.
curses_test.rb - This was the first test script. Its purpose was to test initializing a window and performa a couple of exercises.
win.rb - This was to test working with subwindows.
move.rb - This was to test initializing the player and moving it on screen.
terrain.rb - This was to explore different terrain generation methods.

Log:
4/11/15 - I discovered that the curses library I have been using is inadequate. Specifically, I want the window to follow the player, and this is done in ncurses using a method called mvderwin. This function is missing in curses, and so I'm switching to a ncurses based library.
The new gem is installed by: gem install ncurses-ruby
