# frozen_string_literal: true

module GPXKML
  # The rules a single coordinate component obeys, shared by the KML and the GPX
  # side so that both directions read and write the same set of values.
  module Coordinate
    # An optionally signed decimal. Exponent notation is left out on purpose:
    # GPX 1.1 types latitude and longitude as xsd:decimal, which forbids it, so
    # a coordinate written as '1.0e1' could not be converted without rewriting
    # the value.
    NUMBER = /\A[+-]?(?:\d+(?:\.\d*)?|\.\d+)\z/

    # Ranges KML and GPX both define for a coordinate.
    LONGITUDE_RANGE = (-180.0..180.0)
    LATITUDE_RANGE = (-90.0..90.0)

    def number?(value)
      value.is_a?(String) && NUMBER.match?(value.strip)
    end

    def longitude?(value)
      within?(value, LONGITUDE_RANGE)
    end

    def latitude?(value)
      within?(value, LATITUDE_RANGE)
    end

    private

    def within?(value, range)
      number?(value) && range.cover?(value.to_f)
    end
  end
end
