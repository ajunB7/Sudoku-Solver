require 'pry'
require_relative 'board.rb'

module Sudoku

	class Puzzle
		attr_accessor :board

		def initialize
			@board = Sudoku::Board.new()
		end

		def solve
			recursive_backtrack_search
		end

		private
		def recursive_backtrack_search
			return true unless @board.contains_nil?
			row, column = @board.nil_cell

			(1..Sudoku::Board::BOXSIZE).each do |n|
				if constraints_check(row, column, n)
					@board.values[row][column] = n

					# Means first line returns true and we are finished
					return true if recursive_backtrack_search()

					# Things done messed up and now we gotta backtrack
					@board.values[row][column] = nil

				end
			end
			return false
		end

		def check_box_safe(row,column,value)
			box = @board.box(row,column)
			box.flatten.compact.each do |v|
				return false if v == value
			end
			return true
		end

		def check_row_safe(column, value)
			row = @board.rows(column)
			row.compact.each do |v|
				return false if v == value
			end
			return true
		end

		def check_column_safe(row, value)
			column = @board.columns(row)
			column.compact.each do |v|
				return false if v == value
			end
			return true
		end

		def constraints_check(row, column, value)
			return check_box_safe(row,column,value) && check_row_safe(row, value) && check_column_safe(column,value)
		end

		def to_s
			@board.to_s
		end

	end
end



puzzle = Sudoku::Puzzle.new()
# puts "Enter the row, column, value with values (1-#{Sudoku::Board::BOXSIZE}) for each starting number (Seperated by space)"
#  while true
#  	inp = gets.chomp
#  	break if inp == "q"
#  	res = inp.split()
#  	puzzle.board.values[res[0].to_i - 1][res[1].to_i - 1] = res[2].to_i
#  	puts "Enter more values or Press q to begin"
#  end
def easy(puzzle)
	puzzle.board.values[0][0] = 3
	puzzle.board.values[0][2] = 9
	puzzle.board.values[0][7] = 4
	puzzle.board.values[0][8] = 2

	puzzle.board.values[1][1] = 1
	puzzle.board.values[1][2] = 8
	puzzle.board.values[1][3] = 9
	puzzle.board.values[1][4] = 4
	puzzle.board.values[1][5] = 3
	puzzle.board.values[1][6] = 6

	puzzle.board.values[2][6] = 8
	puzzle.board.values[2][7] = 9

	puzzle.board.values[3][2] = 3
	puzzle.board.values[3][4] = 9
	puzzle.board.values[3][7] = 6

	puzzle.board.values[4][0] = 4
	puzzle.board.values[4][1] = 2
	puzzle.board.values[4][2] = 7
	puzzle.board.values[4][6] = 5
	puzzle.board.values[4][7] = 8
	puzzle.board.values[4][8] = 9

	puzzle.board.values[5][1] = 6
	puzzle.board.values[5][4] = 8
	puzzle.board.values[5][6] = 2

	puzzle.board.values[6][1] = 7
	puzzle.board.values[6][2] = 2

	puzzle.board.values[7][2] = 4
	puzzle.board.values[7][3] = 5
	puzzle.board.values[7][4] = 7
	puzzle.board.values[7][5] = 6
	puzzle.board.values[7][6] = 3
	puzzle.board.values[7][7] = 2

	puzzle.board.values[8][0] = 6
	puzzle.board.values[8][1] = 3
	puzzle.board.values[8][6] = 7
	puzzle.board.values[8][8] = 4

end

puts "Here is your starting Board"
easy(puzzle)
# puzzle.board.to_s
puzzle.solve
puzzle.board.to_s 
# binding.pry

