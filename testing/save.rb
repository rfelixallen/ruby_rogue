require 'ncurses'
include Ncurses

testFile = File.open("save_test.txt", "w")
testFile.puts "Hello file!"
testFile.close 