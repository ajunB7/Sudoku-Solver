require_relative 'sudoku.rb'
require_relative 'possible.rb'
require "benchmark"

module Sudoku

	class SudokuSolverBtFc < Sudoku::Puzzle
		def initialize
			super

		end

		def solve
			@possible = Sudoku::Possible.new(@board)

			# Reset Timers
			@benchmark = 0
			@nodes = 0

			# Execute with benchmark
			@benchmark = Benchmark.measure do
				recursive_backtrack_search
			end
		end

		private
		def recursive_backtrack_search()
			return true unless @board.contains_nil?
			row, column = @board.nil_cell

			@possible.poss[row][column].each do |n|
				if constraints_check(row, column, n)
					@board.values[row][column] = n
					if @possible.set_and_forward_check(row,column)
						@nodes += 1

						# Means first line returns true and we are finished
						return true if recursive_backtrack_search()

						# Things done messed up and now we gotta backtrack
						@board.values[row][column] = nil
						@possible.poss[row][column] = @possible.possibilities(row, column)
					end
				end
			end
			return false
		end

	end
end
