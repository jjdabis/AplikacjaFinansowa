require 'csv'
require_relative 'base_repository'
require_relative '../models/planner'

class PlannerRepository < BaseRepository
  def initialize(data_folder)
    file = File.join(data_folder, 'planner.csv')
    super(file, headers: %i[id type planned_date notes])
  end

  def all
    all_rows.map do |h|
      Planner.new(
        id:           h[:id],
        type:         h[:type],
        planned_date: h[:planned_date],
        notes:        h[:notes]
      )
    end
  end

  def create(attrs)
    id = add_row(attrs)
    h  = find_by_id(id)
    Planner.new(
      id:           h[:id],
      type:         h[:type],
      planned_date: h[:planned_date],
      notes:        h[:notes]
    )
  end

  def find(id)
    h = find_by_id(id)
    return nil unless h

    Planner.new(
      id:           h[:id],
      type:         h[:type],
      planned_date: h[:planned_date],
      notes:        h[:notes]
    )
  end

  def delete(id)
    delete_by_id(id)
  end
end
