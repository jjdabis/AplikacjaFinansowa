require 'date'

class Planner
  attr_accessor :id, :type, :planned_date, :notes

  def initialize(id:, type:, planned_date:, notes: '')
    @id           = id.to_i
    @type         = type
    @planned_date = Date.parse(planned_date)
    @notes        = notes
  end

 def to_h
    {
      id:           @id,
      type:         @type,
      planned_date: @planned_date.to_s,
      notes:        @notes
    }
  end
end
