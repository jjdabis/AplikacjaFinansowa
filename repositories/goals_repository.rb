require 'csv'
require_relative 'base_repository'
require_relative '../models/goals'

class GoalRepository < BaseRepository
  def initialize(data_folder)
    file = File.join(data_folder, 'goals.csv')
    super(file, headers: %i[id name target_amount current_amount deadline completed])
  end

  def all
    all_rows.map do |h|
      Goal.new(
        id:             h[:id],
        name:           h[:name],
        target_amount:  h[:target_amount],
        current_amount: h[:current_amount],
        deadline:       h[:deadline],
        completed:      h[:completed]
      )
    end
  end

  def create(attrs)
    attrs[:completed] ||= false
    id = add_row(attrs)
    h  = find_by_id(id)
    Goal.new(
      id:             h[:id],
      name:           h[:name],
      target_amount:  h[:target_amount],
      current_amount: h[:current_amount],
      deadline:       h[:deadline],
      completed:      h[:completed]
    )
  end

  def find(id)
    h = find_by_id(id)
    return nil unless h

    Goal.new(
      id:             h[:id],
      name:           h[:name],
      target_amount:  h[:target_amount],
      current_amount: h[:current_amount],
      deadline:       h[:deadline],
      completed:      h[:completed]
    )
  end
  
  def update(id, attrs = {})
    updated_hash = super(id, attrs)
    build_entity(updated_hash)
  end

  private

  def build_entity(h)
    Goal.new(
      id:             h[:id],
      name:           h[:name],
      target_amount:  h[:target_amount],
      current_amount: h[:current_amount],
      deadline:       h[:deadline],
      completed:      h[:completed]
    )
  end
  public
  def delete(id)
    delete_by_id(id)
  end
end
