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
      @kml.remove_namespaces!
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

    def kml?
      !@kml.nil? && !@kml.xpath('/kml').empty?
    end

    def valid?
      kml? && (tracks? || routes? || points?)
    end

    def routes?
      return false if @kml.nil?
      return true unless @kml.xpath('//LinearRing').empty?

      false
    end

    def tracks?
      return false if @kml.nil?
      return true unless @kml.xpath('//LineString').empty?

      false
    end

    def points?
      return false if @kml.nil?
      return true unless @kml.xpath('//Point').empty?

      false
    end

    private

    # Whether the path can be read at all. What the file actually is gets
    # decided from its root element by #kml?, not from its extension: an
    # uppercase '.KML' is an ordinary file name, and it is what a Rack
    # tempfile keeps on upload.
    def correct_path?(path)
      path.instance_of?(String) && File.file?(path)
    end

    def _tracks
      t = []
      @kml.xpath('//LineString').each_with_index do |ls, i|
        t[i] = KML::Track.new ls
      end
      t
    end

    def _routes
      r = []
      @kml.xpath('//LinearRing').each_with_index do |lr, i|
        r[i] = KML::Route.new lr
      end
      r
    end

    def _points
      p = []
      @kml.xpath('//Point').each_with_index do |pt, i|
        p[i] = KML::Point.new pt.xpath('./coordinates/text()').to_s, self, pt
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
