require 'date'
require 'bigdecimal'

class Goal
  attr_accessor :id, :name, :target_amount, :current_amount, :deadline, :completed

  def initialize(id:, name:, target_amount:, current_amount:, deadline:, completed: false)
    @id             = id.to_i
    @name           = name
    @target_amount  = BigDecimal(target_amount.to_s)
    @current_amount = BigDecimal(current_amount.to_s)
    @deadline       = Date.parse(deadline)
    @completed      = (completed == true) || (completed.to_s.downcase == 'true')
  end

  def completed?
    @completed
  end

  def to_h
    {
      id:             @id,
      name:           @name,
      target_amount:  sprintf('%.2f', @target_amount),
      current_amount: sprintf('%.2f', @current_amount),
      deadline:       @deadline.to_s,
      completed:      @completed ? 'true' : 'false'
    }
  end
end
