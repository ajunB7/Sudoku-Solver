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

			(1..Sudoku::Board::BOXSIZE).each do |n|
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



# puts "Enter the row, column, value with values (1-#{Sudoku::Board::BOXSIZE}) for each starting number (Seperated by space)"
#  while true
#  	inp = gets.chomp
#  	break if inp == "q"
#  	res = inp.split()
#  	puzzle.board.values[res[0].to_i - 1][res[1].to_i - 1] = res[2].to_i
#  	puts "Enter more values or Press q to begin"
#  end
def easy(puzzle)
	puzzle.board.values = [[3, nil, 9, nil, nil, nil, nil, 4, 2],
				 [nil, 1, 8, 9, 4, 3, 6, nil, nil],
				 [nil, nil, nil, nil, nil, nil, 8, 9, nil],
				 [nil, nil, 3, nil, 9, nil, nil, 6, nil],
				 [4, 2, 7, nil, nil, nil, 5, 8, 9],
				 [nil, 6, nil, nil, 8, nil, 2, nil, nil],
				 [nil, 7, 2, nil, nil, nil, nil, nil, nil],
				 [nil, nil, 4, 5, 7, 6, 3, 2, nil],
				 [6, 3, nil, nil, nil, nil, 7, nil, 4]]
end
num_run = 50
total_benchmark = []
total_nodes = []
num_run.times do |n|
	puzzle = Sudoku::Puzzle.new()
	# Change puzzle difficulty
	easy(puzzle)
	puzzle.solve
	puzzle.board.to_s if n.zero?
	total_benchmark << puzzle.benchmark.real
	total_nodes << puzzle.nodes
	STDOUT.write "\r[#{n+1}/#{num_run}]"
end

puts "\nIt took #{total_benchmark.inject(:+)} seconds to solve #{num_run} times"
stats_time = DescriptiveStatistics::Stats.new(total_benchmark)
stats_nodes = DescriptiveStatistics::Stats.new(total_nodes)
puts "AvgTime: #{stats_time.mean} +/- #{stats_time.standard_deviation}"
puts "AvgNodes: #{stats_nodes.mean} +/- #{stats_nodes.standard_deviation}"

