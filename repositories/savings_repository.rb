require 'csv'
require_relative 'base_repository'
require_relative '../models/savings'

class SavingRepository < BaseRepository
  def initialize(data_folder)
    file = File.join(data_folder, 'savings.csv')
    super(file, headers: %i[id amount date destination description])
  end

  def all
    all_rows.map do |h|
      Saving.new(
        id:          h[:id],
        amount:      h[:amount],
        date:        h[:date],
        destination: h[:destination],
        description: h[:description]
      )
    end
  end

  def create(attrs)
    id = add_row(attrs)
    h  = find_by_id(id)
    Saving.new(
      id:          h[:id],
      amount:      h[:amount],
      date:        h[:date],
      destination: h[:destination],
      description: h[:description]
    )
  end

  def find(id)
    h = find_by_id(id)
    return nil unless h

    Saving.new(
      id:          h[:id],
      amount:      h[:amount],
      date:        h[:date],
      destination: h[:destination],
      description: h[:description]
    )
  end

  def update(id, attrs = {})
    updated_hash = super(id, attrs)
    build_entity(updated_hash)
  end

    def delete(id)
    delete_by_id(id)
  end

  private

  def build_entity(h)
    Saving.new(
      id:          h[:id],
      amount:      h[:amount],
      date:        h[:date],
      destination: h[:destination],
      description: h[:description]
    )
  end
end
