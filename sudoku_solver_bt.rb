require_relative 'sudoku.rb'
require "benchmark"

module Sudoku

	class SudokuSolverBt < Sudoku::Puzzle
		def solve
			# Reset Timers
			@benchmark = 0
			@nodes = 0

			# Execute with benchmark
			@benchmark = Benchmark.measure do
				recursive_backtrack_search
			end
		end

		private
		def recursive_backtrack_search
			return true unless @board.contains_nil?
			row, column = @board.nil_cell

			(1..Sudoku::Board::BOARDSIZE).to_a.shuffle.each do |n|
				if constraints_check(row, column, n)
					@nodes += 1
					@board.values[row][column] = n

					# Means first line returns true and we are finished
					return true if recursive_backtrack_search()

					# Things done messed up and now we gotta backtrack
					@board.values[row][column] = nil

				end
			end
			return false
		end

	end
end



# puts "Enter the row, column, value with values (1-#{Sudoku::Board::BOARDSIZE}) for each starting number (Seperated by space)"
#  while true
#  	inp = gets.chomp
#  	break if inp == "q"
#  	res = inp.split()
#  	puzzle.board.values[res[0].to_i - 1][res[1].to_i - 1] = res[2].to_i
#  	puts "Enter more values or Press q to begin"
#  end

