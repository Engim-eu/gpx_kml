# frozen_string_literal: true

require 'nokogiri'
require 'gpx_kml/kml'
require 'gpx_kml/kml/track'
require 'gpx_kml/kml/route'

module KML
  # Docu
  class Point
    # A single number of a KML coordinate tuple: an optionally signed decimal.
    # Exponent notation is deliberately left out: GPX 1.1 types latitude and
    # longitude as xsd:decimal, which forbids it, so a coordinate written as
    # '1.0e1' could not be converted without rewriting the value.
    NUMBER = /\A[+-]?(?:\d+(?:\.\d*)?|\.\d+)\z/

    # Ranges KML defines for the tuple longitude,latitude[,altitude].
    LONGITUDE_RANGE = (-180.0..180.0)
    LATITUDE_RANGE = (-90.0..90.0)

    def initialize(coord, father, node)
      return unless valid_father?(father) && node.is_a?(Nokogiri::XML::Element)
      return if node.xpath('self::*[self::LineString or self::Point or self::LinearRing]').empty?

      parsed = parse(coord)
      return if parsed.nil?

      @father = father
      @longitude, @latitude, @elevation = parsed
      @node = node
      # Name is looked up in the ancestor of the node that compose this point
      @name = _name
      return if node.xpath('self::Point').empty?

      @author = _author
      @link = _link
    end

    attr_reader :latitude, :longitude, :elevation, :name, :father, :link, :author

    # False when the coordinate tuple could not be read, so that a caller can
    # tell an unusable point from one that merely looks empty.
    def valid?
      !@longitude.nil? && !@latitude.nil?
    end

    private

    # Splits a 'longitude,latitude[,altitude]' tuple and returns its components
    # as they are written in the document, or nil when it is not a coordinate.
    def parse(coord)
      return nil unless coord.is_a?(String) && coord.count(',') <= 2

      longitude, latitude, elevation = coord.strip.split(',').map(&:strip)
      return nil if longitude.nil? || latitude.nil?
      return nil unless in_range?(longitude, LONGITUDE_RANGE) && in_range?(latitude, LATITUDE_RANGE)
      return nil unless elevation.nil? || NUMBER.match?(elevation)

      [longitude, latitude, elevation]
    end

    def in_range?(number, range)
      NUMBER.match?(number) && range.cover?(number.to_f)
    end

    def _name
      elem = @node.xpath('.')
      while elem.xpath('self::kml').empty?
        return elem.xpath('./name/text()').to_s unless elem.xpath('./name').empty?

        elem = elem.xpath('..')
      end
      ''
    end

    def _author
      elem = @node.xpath('.')
      while elem.xpath('self::kml').empty?
        elem = elem.xpath('..')
        return elem.xpath('./author/name/text()').to_s unless elem.xpath('./author').empty?
      end
      ''
    end

    def _link
      elem = @node.xpath('.')
      while elem.xpath('self::kml').empty?
        elem = elem.xpath('..')
        return elem.xpath('./link/@href').to_s unless elem.xpath('./link').empty?
      end
      ''
    end

    def valid_father?(father)
      father.is_a?(KML::Track) || father.is_a?(KML::Kml) || father.is_a?(KML::Route)
    end
  end
end
