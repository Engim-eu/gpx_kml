# frozen_string_literal: true

require 'gpx_kml/coordinate'

module GPX
  # Docu
  class Point
    include GPXKML::Coordinate

    def initialize(point, father)
      return unless point.is_a? Nokogiri::XML::Element
      return if point.xpath('self::*[self::wpt or self::rtept or self::trkpt]').empty?

      @longitude = point.xpath('@lon').to_s.strip
      @latitude = point.xpath('@lat').to_s.strip
      @elevation = normalized_number(point.xpath('./ele/text()').to_s) || ''
      @name = point.xpath('./name/text()').to_s
      @description = point.xpath('./desc/text()').to_s
      @link = point.xpath('./link/@href').to_s
      return unless valid_father? father

      @father = father
    end


    attr_reader :longitude, :latitude, :link, :name, :description, :father, :elevation

    # False when the point carries no usable coordinates, which is what a gpx
    # written by a broken exporter looks like: <trkpt lat="" lon=""/>.
    def valid?
      longitude?(@longitude) && latitude?(@latitude)
    end

    private

    def valid_father?(father)
      father.is_a?(GPX::Segment) || father.is_a?(GPX::Route) || father.is_a?(GPXKML::Gpx)
    end

  end
end
