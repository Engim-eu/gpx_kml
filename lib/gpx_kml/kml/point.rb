# frozen_string_literal: true

require 'nokogiri'
require 'gpx_kml/kml'
require 'gpx_kml/kml/track'
require 'gpx_kml/kml/route'

module KML
  # Docu
  class Point
    def initialize(coord, father, node)
      re = Regexp.new('^ ?[0-9]+\.[0-9]+,[0-9]+\.[0-9]+(,[0-9]+\.[0-9]+)? ?$')

      return unless valid_father?(father) && re.match?(coord) && node.is_a?(Nokogiri::XML::Element)
      return if node.xpath('self::*[self::LineString or self::Point or self::LinearRing]').empty?

      @father = father
      coord = coord.split(',')
      @longitude = coord[0]
      @latitude = coord[1]
      @elevation = coord[2] if coord.length == 3
      @node = node
      # Name is looked up in the ancestor of the node that compose this point
      @name = _name
      return if node.xpath('self::Point').empty?

      @author = _author
      @link = _link
    end

    attr_reader :latitude, :longitude, :elevation, :name, :father, :link, :author

    private

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
