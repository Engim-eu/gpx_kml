# frozen_string_literal: true

require 'gpx_kml/gpx/point'

module GPX
  # Docu
  class Route
    def initialize(route)
      return unless route.is_a?(Nokogiri::XML::Element) && !route.xpath('self::rte').empty?

      @name = route.xpath('./name/text()').to_s
      @number = route.xpath('./number/text()').to_s
      @description = route.xpath('./desc/text()').to_s
      @link = route.xpath('./link/@href').to_s
      @points = _points route
    end

    attr_reader :name, :link, :points, :description, :number, :time

    private

    def _points(route)
      route_points = []
      route.xpath('./rtept').each_with_index do |rp, i|
        route_points[i] = Point.new(rp, self)
      end
      route_points
    end
  end
end
