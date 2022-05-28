# frozen_string_literal: true

class Cell
  VALID_EMPTY_STATES = ['.', ' '].freeze

  attr_reader :num_active_neighbors, :neighbors

  def initialize(value:, neighbors:)
    @alive = !VALID_EMPTY_STATES.include?(value)
    @num_active_neighbors = 0
    @neighbors = neighbors
  end

  def increment_active_neighbors
    @num_active_neighbors += 1
  end

  def alive?
    @alive
  end

  def dead?
    !alive?
  end

  def die!
    @alive = false
  end

  def live!
    @alive = true
  end

  def correct_population_to_survive?
    (num_active_neighbors == 2 || num_active_neighbors == 3)
  end

  def materialize!
    # This method is the primary logic of Conway's
    # Game of Life.
    if alive? && correct_population_to_survive?
      live!
    elsif dead? && num_active_neighbors == 3
      live!
    else
      die!
    end

    # Reset for next iteration
    @num_active_neighbors = 0
  end

  def to_s
    alive? ? '█' : ' '
  end

  def self.find_neighbors(cell, height, width)
    adjacent_cells = []

    # Determine which boundaries we might be hitting
    hitting_top_boundary = cell < width
    hitting_left_boundary = (cell % width).zero?
    hitting_right_boundary = ((cell + 1) % width).zero?
    hitting_bottom_boundary = cell >= height * width - width

    unless hitting_top_boundary
      # Top Left
      adjacent_cells << cell - width - 1 unless hitting_left_boundary
      # Top Center
      adjacent_cells << cell - width
      # Top Right
      adjacent_cells << cell - width + 1 unless hitting_right_boundary
    end

    # Middle Left
    adjacent_cells << cell - 1 unless hitting_left_boundary
    # Middle Right
    adjacent_cells << cell + 1 unless hitting_right_boundary

    unless hitting_bottom_boundary
      # Bottom Left
      adjacent_cells << cell + width - 1 unless hitting_left_boundary
      # Bottom Center
      adjacent_cells << cell + width
      # Bottom Right
      adjacent_cells << cell + width + 1 unless hitting_right_boundary
    end

    adjacent_cells
  end
end
