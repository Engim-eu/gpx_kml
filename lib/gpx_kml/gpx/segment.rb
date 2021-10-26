# frozen_string_literal: true

require 'gpx_kml/gpx/point'

module GPX

  class Segment

    def initialize(segment, track)
      return unless segment.is_a?(Nokogiri::XML::Element) && track.is_a?(GPX::Track)
      return if segment.xpath('self::xmlns:trkseg').empty?

      @points = _points segment
      @track = track
    end

    attr_reader :track, :points

    private

    def _points(segment)
      p = []
      segment.xpath('./xmlns:trkpt').each_with_index do |tp, i|
        p[i] = Point.new(tp, self)
      end
      p
    end
  end

end
