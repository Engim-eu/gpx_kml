# frozen_string_literal: true

require 'nokogiri'
require 'gpx_kml/gpx/track'
require 'gpx_kml/gpx/route'
require 'gpx_kml/gpx/point'

# Docu
module GPX
  # Docu
  class Gpx
    def initialize(file_path)
      return unless correct_path?(file_path) && (File.size(file_path) < 10_000_000)

      @gpx = Nokogiri::XML(File.open(file_path))
      return unless valid?

      @file_name = File.basename(file_path)
      @name = _name
      @author = @gpx.xpath('/xmlns:gpx/xmlns:metadata/xmlns:author/xmlns:name/text()').to_s
      @link = @gpx.xpath('/xmlns:gpx/xmlns:metadata/xmlns:link/@href').to_s
      @tracks = _tracks if tracks?
      @routes = _routes if routes?
      @points = _points if points?
      @points_length = _points_length
      @routes_length = _routes_length
      @tracks_length = _tracks_length
    end
    # used in development of the gem, could be useful going forward to add functionalities
    # attr_reader :gpx
    attr_reader :tracks, :points, :routes, :name, :file_name, :author, :link

    # access in readonly to the quantity of points/routes/tracks in the gpx
    attr_reader :points_length, :routes_length, :tracks_length

    # For a gpx file to be valid it must only have a waypoint, a route or a track
    def valid?
      tracks? || routes? || points?
    end

    def routes?
      return true unless @gpx.xpath('//xmlns:rte').empty?

      false
    end

    def tracks?
      return true unless @gpx.xpath('//xmlns:trk').empty?

      false
    end

    def points?
      return true unless @gpx.xpath('//xmlns:wpt').empty?

      false
    end

    def _name
      if valid?
        name = @gpx.xpath('/xmlns:gpx/xmlns:metadata/xmlns:name/text()').to_s
        return alt_name if name.empty?

        return name
      end
      puts 'return empty string'
      ''
    end

    def description
      return @gpx.xpath('//xmlns:metadata/xmlns:desc/text()').to_s if valid?

      ''
    end

    private

    def _tracks
      t = []
      @gpx.xpath('xmlns:gpx/xmlns:trk').each_with_index do |trk, i|
        t[i] = GPX::Track.new trk
      end
      t
    end

    def _routes
      r = []
      @gpx.xpath('xmlns:gpx/xmlns:rte').each_with_index do |rte, i|
        r[i] = GPX::Route.new rte
      end
      r
    end

    def _points
      p = []
      @gpx.xpath('xmlns:gpx/xmlns:wpt').each_with_index do |wpt, i|
        p[i] = GPX::Point.new wpt, self
      end
      p
    end

    def _tracks_length
      return 0 if @tracks.nil?

      @tracks.length
    end

    def _routes_length
      return 0 if @routes.nil?

      @routes.length
    end

    def _points_length
      return 0 if @points.nil?

      @points.length
    end

    def correct_path?(path)
      return true if path.instance_of?(String) && (path.end_with? '.gpx')

      false
    end

    def alt_name
      node = nil
      node = @gpx.xpath('//xmlns:wpt')[0] if points?
      node = @gpx.xpath('//xmlns:trk')[0] if tracks?
      node = @gpx.xpath('//xmlns:rte')[0] if routes?
      return node.xpath('./xmlns:name/text()').to_s unless node.nil?

      ''
    end
  end
end
