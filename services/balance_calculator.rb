require 'date'
require 'bigdecimal'
require_relative 'validator'

class BalanceCalculator
  def initialize(inflow_repo, expense_repo, saving_repo, goal_repo = nil)
    @inflow_repo  = inflow_repo
    @expense_repo = expense_repo
    @saving_repo  = saving_repo
    @goal_repo    = goal_repo 
  end

  def balance_in_range(from_date: nil, to_date: nil)
    inflows  = filter_by_date(@inflow_repo.all, from_date, to_date)
    expenses = filter_by_date(@expense_repo.all, from_date, to_date)
    savings  = filter_by_date(@saving_repo.all, from_date, to_date)
    
    inflow_sum  = inflows.sum(&:amount)
    expense_sum = expenses.sum(&:amount)
    saving_sum  = savings.sum(&:amount)
    balance     = inflow_sum - expense_sum + saving_sum

    {
      inflows: inflow_sum,
      expenses: expense_sum,
      savings: saving_sum,
      balance: balance
    }
  end

  def goals_progress
    return [] unless @goal_repo
    
    @goal_repo.all.map do |goal|
      {
        goal: goal,
        progress: ((goal.current_amount / goal.target_amount) * 100).to_f.round(2)
      }
    end
  end

  private

  def total_inflows
    @inflow_repo.all.sum(&:amount)
  end

  def total_expenses
    @expense_repo.all.sum(&:amount)
  end

  def total_savings
    @saving_repo.all.sum(&:amount)
  end

  def filter_by_date(records, from_date, to_date)
    records.select do |record|
      (from_date.nil? || record.date >= from_date) &&
      (to_date.nil? || record.date <= to_date)
    end
  end
end