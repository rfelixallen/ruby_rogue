ruby_rogue
==========

The purpose of this repo is to recreate a roguelike tutorial in Ruby. See original tutorial: https://solarianprogrammer.com/2012/07/12/roguelike-game-cpp-11-part-0/

TODOS - FEATURES
* Move code to header files
* Create Game Menu
* Incorporate Save/Load feature

Files:
main.rb - This is the main game file

Log:
4/11/15 - I discovered that the curses library I have been using is inadequate. Specifically, I want the window to follow the player, and this is done in ncurses using a method called mvderwin. This function is missing in curses, and so I'm switching to a ncurses based library.
The new gem is installed by: gem install ncurses-ruby

5/5/15 - The new ncurses library was exactly what I needed and fixed a lot of problems. So far, Ive added in navigable terrain, a monster, hit points, and the very beginnings of an inventory system. Ive taken a break to reorganize my folder structure. Ive moved my work back into main.rb and commented the hell out of it so Ill know what does what if I forget about it for a month. Manually updating large blocks of code was novel at first but is becoming cumbersome. My next step is to refactor code before adding new features.