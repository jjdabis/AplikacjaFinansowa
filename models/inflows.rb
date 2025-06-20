
require 'date'
require 'bigdecimal'

class Inflow
  attr_accessor :id, :amount, :date, :source, :description

  def initialize(id:, amount:, date:, source:, description: '')
    @id          = id.to_i
    @amount      = BigDecimal(amount.to_s)
    @date        = Date.parse(date)
    @source      = source
    @description = description
  end

  def to_h
    {
      id:          @id,
      amount:      sprintf('%.2f', @amount),
      date:        @date.to_s,
      source:      @source,
      description: @description
    }
  end
end
