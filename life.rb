# frozen_string_literal: true

require './cell'

class Life
  attr_reader :current_iteration

  def initialize(seed:)
    @current_iteration = 0
    @cells = []
    seed_array = seed.split("\n")
    @width = seed_array.map(&:size).max
    @height = seed_array.size

    # Make sure all lines are the right length
    # and pad with spaces if needed
    seed_array = seed_array.map { |row| row.ljust(@width, ' ') }

    # Turn each character of the seed file into a cell
    seed_array.join('').split('').each_with_index do |value, index|
      neighbors = Cell.find_neighbors(index, @height, @width)
      @cells << Cell.new(value: value, neighbors: neighbors)
    end
  end

  def rows
    @cells.each_slice(@width)
  end

  def to_grid
    rows.map { |row| row.map(&:to_s).join('') }.join("\n")
  end

  def advance
    @current_iteration += 1

    # For each active cell, we increment it's
    # neighbor's "active_neighbors" count.
    @cells.each_with_index do |cell, _index|
      next unless cell.alive?

      cell.neighbors.each do |cell_to_increment|
        @cells[cell_to_increment].increment_active_neighbors
      end
    end

    # Now that all cells know their current state,
    # we finalize it them, mutating them to the
    # next "frame" of life.
    @cells.each(&:materialize!)
  end
end
