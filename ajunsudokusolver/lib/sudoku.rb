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


