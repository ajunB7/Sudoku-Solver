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

	def medium
		@values = [[nil, nil, nil, 1, 2, nil, nil, 3, nil],
					 [nil, nil, 3, nil, 8, nil, nil, 1, 6],
					 [4, nil, nil, 5, 3, nil, nil, 9, nil],
					 [nil, 1, nil, 8, nil, nil, 5, 2, nil],
					 [nil, 4, nil, nil, nil, nil, nil, 6, nil],
					 [nil, 6, 8, nil, nil, 2, nil, 7, nil],
					 [nil, 8, nil, nil, 9, 3, nil, nil, 2],
					 [6, 9, nil, nil, 5, nil, 3, nil, nil],
					 [nil, 3, nil, nil, 4, 8, nil, nil, nil]]
	end

	def hard
		@values = [[6, nil, nil, 8, nil, 9, nil, nil, nil],
					 [nil, nil, 5, nil, nil, 7, nil, 8, 6],
					 [nil, 7, nil, nil, nil, nil, nil, nil, nil],
					 [nil, nil, nil, 4, nil, 1, 3, nil, 7],
					 [8, nil, 1, nil, nil, nil, 5, nil, 4],
					 [7, nil, 9, 2, nil, 5, nil, nil, nil],
					 [nil, nil, nil, nil, nil, nil, nil, 4, nil],
					 [1, 8, nil, 5, nil, nil, 6, nil, nil],
					 [nil, nil, nil, 3, nil, 4, nil, nil, 5]]
	end

	def evil
		@values = [[1, nil, nil, nil, nil, nil, nil, nil, nil],
					 [7, nil, nil, nil, nil, 8, 1, nil, 2],
					 [nil, 6, 3, nil, 5, nil, nil, nil, nil],
					 [nil, 7, nil, 3, 9, nil, nil, nil, nil],
					 [nil, nil, 5, 8, nil, 4, 6, nil, nil],
					 [nil, nil, nil, nil, 2, 5, nil, 4, nil],
					 [nil, nil, nil, nil, 1, nil, 8, 7, nil],
					 [2, nil, 8, 9, nil, nil, nil, nil, 3],
					 [nil, nil, nil, nil, nil, nil, nil, nil, 6]]
	end
end
