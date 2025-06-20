require 'csv'
require_relative 'base_repository'
require_relative '../models/expenses'

class ExpenseRepository < BaseRepository
  def initialize(data_folder)
    file = File.join(data_folder, 'expenses.csv')
    super(file, headers: %i[id amount date category description])
  end

  def all
    all_rows.map do |h|
      Expense.new(
        id:          h[:id],
        amount:      h[:amount],
        date:        h[:date],
        category:    h[:category],
        description: h[:description]
      )
    end
  end

  def create(attrs)
    id = add_row(attrs)
    h  = find_by_id(id)
    Expense.new(
      id:          h[:id],
      amount:      h[:amount],
      date:        h[:date],
      category:    h[:category],
      description: h[:description]
    )
  end

 def find(id)
    h = find_by_id(id)
    return nil unless h

    Expense.new(
      id:          h[:id],
      amount:      h[:amount],
      date:        h[:date],
      category:    h[:category],
      description: h[:description]
    )
  end

    def update(id, attrs = {})
    updated_hash = super(id, attrs)
    build_entity(updated_hash)
  end

  private

  def build_entity(h)
    Expense.new(
      id:          h[:id],
      amount:      h[:amount],
      date:        h[:date],
      category:    h[:category],
      description: h[:description]
    )
  end
  public
  def delete(id)
    delete_by_id(id)
  end
end
