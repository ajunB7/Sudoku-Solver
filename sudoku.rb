require 'pry'
require_relative 'board.rb'
require 'descriptive-statistics'
require "benchmark"


module Sudoku

	class Puzzle
		attr_accessor :board
		attr_reader :benchmark, :nodes


		def initialize
			@board = Sudoku::Board.new()
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

		def easy
			@board.values = [[3, nil, 9, nil, nil, nil, nil, 4, 2],
				 [nil, 1, 8, 9, 4, 3, 6, nil, nil],
				 [nil, nil, nil, nil, nil, nil, 8, 9, nil],
				 [nil, nil, 3, nil, 9, nil, nil, 6, nil],
				 [4, 2, 7, nil, nil, nil, 5, 8, 9],
				 [nil, 6, nil, nil, 8, nil, 2, nil, nil],
				 [nil, 7, 2, nil, nil, nil, nil, nil, nil],
				 [nil, nil, 4, 5, 7, 6, 3, 2, nil],
				 [6, 3, nil, nil, nil, nil, 7, nil, 4]]
		end

	end
end




