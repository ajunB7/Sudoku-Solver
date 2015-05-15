require 'terminal-table'

module Sudoku
	class Board

		BOXSIZE = 9
		SQUARESIZE = 3
		attr_accessor :values

		def initialize
			@values = Array.new(BOXSIZE){Array.new(BOXSIZE)}
		end

		# Get the box given any cells location
		def box(row,column)
			box_start_row = (row/SQUARESIZE).floor * SQUARESIZE
			box_start_column = (column/SQUARESIZE).floor * SQUARESIZE

			box = Array.new(SQUARESIZE){Array.new(SQUARESIZE)}

			(0...SQUARESIZE).each do |i|
				(0...SQUARESIZE).each do |j|
					box[i][j] = @values[box_start_row + i][box_start_column + j]
				end
			end

			return box
		end

		def rows(column)
			return @values[0...9][column]
		end

		def columns(row)
			return @values[0...9].map do |r|
				r[row]
			end
		end

		def contains_nil?
			return @values.flatten.include?(nil)
		end

		def nil_cell
			(0...BOXSIZE).each do |i|
				(0...BOXSIZE).each do |j|
					return i,j if @values[i][j].nil?
				end
			end
		end

		def to_s
			output = Terminal::Table.new do |t|
				(0...BOXSIZE).each do |row|
					t << @values[row]
					t << :separator unless (row+1) == BOXSIZE
				end
			end
			puts output
		end
	end
end