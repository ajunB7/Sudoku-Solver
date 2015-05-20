require 'pry'
require_relative 'sudoku_solver_bt.rb'
require_relative 'sudoku_solver_bt_fc.rb'
require_relative 'sudoku_solver_bt_fc_h.rb'
require 'descriptive-statistics'

num_run = 50
total_benchmark = []
total_nodes = []
num_run.times do |n|
	puzzle = Sudoku::SudokuSolverBtFcH.new()
	# puzzle = Sudoku::SudokuSolverBtFc.new()
	# puzzle = Sudoku::SudokuSolverBt.new()
	# Change puzzle difficulty
	puzzle.easy
	# puzzle.medium
	puzzle.board.to_s if n.zero?
	puzzle.board.to_s if n.zero?
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

# puzzle = Sudoku::SudokuSolverBtFc.new()
# puzzle.easy
# puzzle.solve
# puzzle.to_s