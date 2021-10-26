# frozen_string_literal: true

require 'gpx_kml/gpx/point'

module GPX
  # Docu
  class Route
    def initialize(route)
      return unless route.is_a?(Nokogiri::XML::Element) && !route.xpath('self::xmlns:rte').empty?

      @name = route.xpath('./xmlns:name/text()').to_s
      @number = route.xpath('./xmlns:number/text()').to_s
      @description = route.xpath('./xmlns:desc/text()').to_s
      @link = route.xpath('./xmlns:link/@href').to_s
      @points = _points route
    end

    attr_reader :name, :link, :points, :description, :number, :time

    private

    def _points(route)
      route_points = []
      route.xpath('./xmlns:rtept').each_with_index do |rp, i|
        route_points[i] = Point.new(rp, self)
      end
      route_points
    end
  end
end
