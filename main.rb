require 'pry'
require_relative 'sudoku_solver_bt.rb'
require_relative 'sudoku_solver_bt_fc.rb'
require_relative 'sudoku_solver_bt_fc_h.rb'
require 'descriptive-statistics'

# TODO: Use OptionParse to provide the type of puzzle and difficulty

num_run = 50
total_benchmark = []
total_nodes = []
num_run.times do |n|
	# ========================
	# Choose the Type of solve
	# ========================
	puzzle = Sudoku::SudokuSolverBtFcH.new()
	# puzzle = Sudoku::SudokuSolverBtFc.new()
	# puzzle = Sudoku::SudokuSolverBt.new()
	
	# ========================
	# Change puzzle difficulty
	# ========================
	puzzle.easy
	# puzzle.medium
	# puzzle.hard
	# puzzle.evil

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
puts "AvgTime: #{stats_time.mean.round(4)} +/- #{stats_time.standard_deviation.round(4)}"
puts "AvgNodes: #{stats_nodes.mean.round(4)} +/- #{stats_nodes.standard_deviation.round(4)}"