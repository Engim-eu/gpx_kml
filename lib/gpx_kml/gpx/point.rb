# frozen_string_literal: true

module GPX
  # Docu
  class Point

    def initialize(point, father)
      return unless point.is_a? Nokogiri::XML::Element
      return if point.xpath('self::*[self::xmlns:wpt or self::xmlns:rtept or self::xmlns:trkpt]').empty?

      @longitude = point.xpath('@lon').to_s
      @latitude = point.xpath('@lat').to_s
      @elevation = point.xpath('./xmlns:ele/text()').to_s
      @name = point.xpath('./xmlns:name/text()').to_s
      @description = point.xpath('./xmlns:desc/text()').to_s
      @link = point.xpath('./xmlns:link/@href').to_s
      return unless valid_father? father

      @father = father
    end


    attr_reader :longitude, :latitude, :link, :name, :description, :father, :elevation

    private

    def valid_father?(father)
      father.is_a?(GPX::Segment) || father.is_a?(GPX::Route) || father.is_a?(GPXKML::Gpx)
    end

  end
end
