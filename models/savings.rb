require 'date'
require 'bigdecimal'

class Saving
  attr_accessor :id, :amount, :date, :destination, :description

  def initialize(id:, amount:, date:, destination:, description: '')
    @id          = id.to_i
    @amount      = BigDecimal(amount.to_s)
    @date        = Date.parse(date)
    @destination = destination
    @description = description
  end

  def to_h
    {
      id:          @id,
      amount:      sprintf('%.2f', @amount),
      date:        @date.to_s,
      destination: @destination,
      description: @description
    }
  end
end
