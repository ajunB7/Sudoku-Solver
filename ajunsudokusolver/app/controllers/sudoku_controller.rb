class SudokuController < ApplicationController
	def index

	end

	def create
		puzzle = Sudoku::Puzzle.new()
		params["form"].each do |p|
			row,column = p[0].split("-")
			if p[1].blank?
				value = nil 
			else 
				value = p[1].to_i
			end
			puzzle.board.values[row.to_i][column.to_i] = value
		end

		puzzle.solve
		@board = puzzle.board.values
	end

	def easy
	@values =  [[3, nil, 9, nil, nil, nil, nil, 4, 2],
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
