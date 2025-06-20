require 'csv'
require_relative 'base_repository'
require_relative '../models/inflows'

class InflowRepository < BaseRepository
  def initialize(data_folder)
    file = File.join(data_folder, 'inflows.csv')
    super(file, headers: %i[id amount date source description])
  end

  def all
    all_rows.map do |h|
      Inflow.new(
        id:          h[:id],
        amount:      h[:amount],
        date:        h[:date],
        source:      h[:source],
        description: h[:description]
      )
    end
  end

  def create(attrs)
    id = add_row(attrs)
    h  = find_by_id(id)
    Inflow.new(
      id:          h[:id],
      amount:      h[:amount],
      date:        h[:date],
      source:      h[:source],
      description: h[:description]
    )
  end

  def find(id)
    h = find_by_id(id)
    return nil unless h

    Inflow.new(
      id:          h[:id],
      amount:      h[:amount],
      date:        h[:date],
      source:      h[:source],
      description: h[:description]
    )
  end

  def delete(id)
    delete_by_id(id)
  end

  def update(id, attrs = {})
    updated_hash = super(id, attrs)
    build_entity(updated_hash)
  end

  private

  def build_entity(h)
    Inflow.new(
      id:          h[:id],
      amount:      h[:amount],
      date:        h[:date],
      source:      h[:source],
      description: h[:description]
    )
  end
end
