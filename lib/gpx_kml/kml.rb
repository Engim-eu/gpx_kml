# frozen_string_literal: true

require 'nokogiri'
require 'gpx_kml/kml/point'
require 'gpx_kml/kml/track'
require 'gpx_kml/kml/route'

module KML
  # Docu
  class Kml
    def initialize(file_path)
      return unless correct_path?(file_path) && (File.size(file_path) < 10_000_000)

      @kml = Nokogiri::XML(File.open(file_path))
      return unless valid?

      @file_name = File.basename(file_path)
      @tracks = _tracks
      @routes = _routes
      @points = _points
      @points_length = _points_length
      @routes_length = _routes_length
      @tracks_length = _tracks_length
    end

    # access in read only of the number of points, routes and tracks in the kml
    attr_reader :points_length, :routes_length, :tracks_length, :file_name

    # access data of the kml in readonly
    attr_reader :points, :routes, :tracks

    def valid?
      return nil if @kml.nil?

      !@kml.xpath('/xmlns:kml').empty? && (tracks? || routes? || points?)
    end

    def routes?
      return true unless @kml.xpath('//xmlns:LinearRing').empty?

      false
    end

    def tracks?
      return true unless @kml.xpath('//xmlns:LineString').empty?

      false
    end

    def points?
      return true unless @kml.xpath('//xmlns:Point').empty?

      false
    end

    private

    def correct_path?(path)
      path.instance_of?(String) && (path.end_with?('.kml') || path.end_with?('.xml') || !path.include?('.'))
    end

    def _tracks
      t = []
      @kml.xpath('//xmlns:LineString').each_with_index do |ls, i|
        t[i] = KML::Track.new ls
      end
      t
    end

    def _routes
      r = []
      @kml.xpath('//xmlns:LinearRing').each_with_index do |lr, i|
        r[i] = KML::Route.new lr
      end
      r
    end

    def _points
      p = []
      @kml.xpath('//xmlns:Point').each_with_index do |pt, i|
        p[i] = KML::Point.new pt.xpath('./xmlns:coordinates/text()').to_s, self, pt
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

  end
end
