require 'bigdecimal'
require 'date'

module Validator
  class << self
    def parse_decimal(input)
      BigDecimal(input.to_s)
    rescue ArgumentError, TypeError
      nil
    end

    def parse_date(input)
      Date.iso8601(input.to_s)
    rescue ArgumentError, TypeError
      nil
    end

    def presence(input)
      s = input.to_s.strip
      s.empty? ? nil : s
    end

    def positive_amount(input)
      dec = parse_decimal(input)
      dec && dec > 0 ? dec : nil
    end

    def valid_id?(input)
      Integer(input) > 0
    rescue ArgumentError, TypeError
      false
    end

    def date_range_valid?(from, to)
      return true if from.nil? || to.nil?
      from <= to
    end
  end
end
