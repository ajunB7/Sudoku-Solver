require_relative 'sudoku_bt_fc_h.rb'
require "benchmark"

module Sudoku

	class SudokuBtFcH < Sudoku::SudokuBtFc
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
			row, column = most_constrained_var


			least_constraining_value(row,column).each do |n|
				if constraints_check(row, column, n)
					@board.values[row][column] = n

					if @possible.set_and_forward_check(row,column)
						@nodes += 1

						# Means first line returns true and we are finished
						return true if recursive_backtrack_search()

						# Reset All
						@board.values[row][column] = nil
						# More like just set
						@possible.set_and_forward_check(row,column)
					end
				end
			end

			# Everything is wrong fix it!
			return false
		end

		# Choose the one with the most amount of nils in constraints
		def most_constraining_var(row,column)
			res = count_nil_box(row,column)

			box_start_row, box_start_column = @board.box_location(row,column)

			res += count_nil_row_minus_box(column, box_start_row, box_start_column)
			res += count_nil_column_minus_box(row,column, box_start_row, box_start_column)

			return res
		end

		# Choose the cell with the least posibilities
		# Choose the variable which has the fewest “legal” moves
		def most_constrained_var
			most_const_row = nil
			most_const_column = nil
			most_constraining_var = 0
			
			# Go through the board
			Sudoku::Board::BOARDSIZE.times do |row|
				Sudoku::Board::BOARDSIZE.times do |column|
					next unless @board.values[row][column].nil?
					next if @possible.poss[row][column].nil?

					# Found the most constraining variable
					if (most_const_row.nil? and most_const_column.nil?) or 
						@possible.poss[row][column].count < @possible.poss[most_const_row][most_const_column].count 
						most_const_row,most_const_column  = row, column
					# Found a tie with both having most constraining variable
					elsif @possible.poss[row][column].count == @possible.poss[most_const_row][most_const_column].count 
						# Choose the ones with the most amont of choises left in box, row, column
						constraining_var = most_constraining_var(row,column)
						if constraining_var > most_constraining_var
							most_constraining_var = constraining_var
							most_const_row,most_const_column  = row, column
						end
					end


				end
			end

			return most_const_row, most_const_column

		end

		# how many other in constraints have the same possibility
		def least_constraining_value(row,column)
			box_start_row, box_start_column = @board.box_location(row,column)
			res = Hash.new
			res = count_constraing_least_in_box(row,column,box_start_row,box_start_column, res)


			res = count_constraing_least_in_row(row, column, box_start_row, box_start_column, res)
			res = count_constraing_least_in_column(row,column, box_start_row, box_start_column, res)
			
			return res.keys.sort {|a, b| res[a] <=> res[b]}
		end

		# Count nil in box
		def count_nil_box(row,column)
			box = @board.box(row,column)
			return box.flatten.count(nil)
		end

		# count nil in row (- box)
		def count_nil_row_minus_box(column,box_start_row,box_start_column)
			res = 0
			# count nil in row (- box)
			((0...Sudoku::Board::BOARDSIZE).to_a - (box_start_row...(box_start_row + Sudoku::Board::SQUARESIZE)).to_a).each do |row_exclude|
				res += 1 if @board.values[row_exclude][column].nil? 
			end
			return res
		end

		# count nil in column (- box)
		def count_nil_column_minus_box(row, column_counted ,box_start_row,box_start_column)
			res = 0
			# count nil in column (- box)
			# Column counted by count_nil_row_minus_box
			((0...Sudoku::Board::BOARDSIZE).to_a - (box_start_column...(box_start_column + Sudoku::Board::SQUARESIZE)).to_a).each do |column_exclude|
				next if column_counted == column_exclude
				res += 1 if @board.values[row][column_exclude].nil? 
			end

			return res
		end

		def count_constraing_least_in_box(row,column,box_start_row,box_start_column, res)
			(box_start_row...(box_start_row + Sudoku::Board::SQUARESIZE)).to_a.each do |i|
				(box_start_column...(box_start_column + Sudoku::Board::SQUARESIZE)).to_a.each do |j|
					next if @possible.poss[i][j].nil?
					@possible.poss[i][j].each do |p|
						next unless @possible.poss[row][column].include?(p)
						res[p] ||= 0
						res[p] += 1
					end

				end
			end

			return res
		end

		def count_constraing_least_in_row(row, column,box_start_row,box_start_column,res)
			((0...Sudoku::Board::BOARDSIZE).to_a - (box_start_row...(box_start_row + Sudoku::Board::SQUARESIZE)).to_a).each do |row_exclude|
				next if @possible.poss[row_exclude][column].nil?
					@possible.poss[row_exclude][column].each do |p|
						next unless @possible.poss[row][column].include?(p)
						res[p] ||= 0
						res[p] += 1
					end
			end
			return res
		end

		def count_constraing_least_in_column(row, column_counted ,box_start_row,box_start_column,res)
			((0...Sudoku::Board::BOARDSIZE).to_a - (box_start_column...(box_start_column + Sudoku::Board::SQUARESIZE)).to_a).each do |column_exclude|
				next if column_counted == column_exclude
				next if @possible.poss[row][column_exclude].nil?
				@possible.poss[row][column_exclude].each do |p|
					next unless @possible.poss[row][column_counted].include?(p)
					res[p] ||= 0
					res[p] += 1
				end
			end

			return res
		end

	end
end
