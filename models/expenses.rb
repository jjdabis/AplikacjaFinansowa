require 'date'
require 'bigdecimal'

class Expense
  attr_accessor :id, :amount, :date, :category, :description

  def initialize(id:, amount:, date:, category:, description: '')
    @id          = id.to_i
    @amount      = BigDecimal(amount.to_s)
    @date        = Date.parse(date)
    @category    = category
    @description = description
  end

  def to_h
    {
      id:          @id,
      amount:      sprintf('%.2f', @amount),
      date:        @date.to_s,
      category:    @category,
      description: @description
    }
  end
end
