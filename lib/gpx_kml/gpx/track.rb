# frozen_string_literal: true

require 'gpx_kml/gpx/segment'

module GPX
  # Docu
  class Track
    def initialize(track)
      return unless track.is_a?(Nokogiri::XML::Element) && !track.xpath('self::xmlns:trk').empty?

      @name = track.xpath('./xmlns:name/text()').to_s
      @number = track.xpath('./xmlns:number/text()').to_s
      @description = track.xpath('./xmlns:desc/text()').to_s
      @link = track.xpath('./xmlns:link/@href').to_s
      @segments = _segments track
    end

    attr_reader :segments, :name, :description, :link, :number

    private

    def _segments(track)
      track_segment = []
      track.xpath('./xmlns:trkseg').each_with_index do |ts, i|
        track_segment[i] = Segment.new(ts, self)
      end
      track_segment
    end
  end
end
