require_relative 'board.rb'
require "benchmark"

module Sudoku
	class Possible
		attr_reader :poss

		def initialize(board)
			@board = board
			@poss = Array.new(Sudoku::Board::BOARDSIZE){Array.new(Sudoku::Board::BOARDSIZE)}
			init_possibilities()

		end

		# Give everything that has no value a possibility of (1-9)
		def init_possibilities
			Sudoku::Board::BOARDSIZE.times do |row|
				Sudoku::Board::BOARDSIZE.times do |column|
					if @board.values[row][column].nil?
						# These are the possibilities
						@poss[row][column] = possibilities(row,column)
					else
						# There's already a value there so there are no possibilities
						@poss[row][column] = nil
					end
					
				end
			end
		end

		def set_and_forward_check(row,column)
			@poss[row][column] = possibilities(row,column)
			set_and_check_valid_set(row,column)

		end

		# Return all of the possibile values for a given cell
		# Gives the intersections from the 3 checks 
		def possibilities(row,column)
			return check_square_possibilities(row,column) & check_row_possibility(row) & check_column_possibility(column)
		end


		private

		def set_and_check_valid_set(row,column)
			# if any of these are corrupt
			if fail_set_box(row,column) or fail_set_row(row) or fail_set_column(column)
				@board.values[row][column] = nil
				return false
			else 
				@poss[row][column] = nil
				return true
			end
		end

		def fail_set_box(row,column)
			box_start_row, box_start_column = @board.box_location(row,column)
			

			(box_start_row...(box_start_row + Sudoku::Board::SQUARESIZE)).to_a.each do |i|
				(box_start_column...(box_start_column + Sudoku::Board::SQUARESIZE)).to_a.each do |j|
					# Set the value with possibilities
					@poss[i][j] = possibilities(i,j) if @board.values[i][j].nil?
					next if @poss[i][j].nil?
					# Here we have a blank cell but there are no possible numbers that can go here
					return true if @poss[i][j].empty? and @board.values[i][j].nil?
				end
			end

			return false
		end

		def fail_set_row(row)
			row_array = (0...Sudoku::Board::BOARDSIZE).to_a
			

			row_array.each do |column|
				 @poss[row][column] = possibilities(row,column) if @board.values[row][column].nil?

				next if @poss[row][column].nil?
				return true if @poss[row][column].empty? and @board.values[row][column].nil?
			end

			return false
		end

		def fail_set_column(column)
			column_array = (0...Sudoku::Board::BOARDSIZE).to_a
			

			column_array.each do |row|
				 @poss[row][column] = possibilities(row,column) if @board.values[row][column].nil?

				next if @poss[row][column].nil?
				return true if @poss[row][column].empty? and @board.values[row][column].nil?
			end
			
			return false
		end



		# if the box has 1,2,3 return 4,5,6,7,8,9 as possible values left
		def check_square_possibilities(row, column)
			box = @board.box(row,column)
			res = box.flatten.compact.uniq
			return ((1..Sudoku::Board::BOARDSIZE).to_a - res)
		end

		def check_row_possibility(row)
			column = @board.rows(row)
			return ((1..Sudoku::Board::BOARDSIZE).to_a - column.compact)
		end

		def check_column_possibility(column)
			row = @board.columns(column)
			return ((1..Sudoku::Board::BOARDSIZE).to_a - row.compact)
		end
	end

end
