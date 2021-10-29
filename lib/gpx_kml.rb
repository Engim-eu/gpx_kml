# frozen_string_literal: true

require 'gpx_kml/version'
require 'gpx_kml/gpx'
require 'gpx_kml/kml'
require 'converter'

module GPXKML

  include GPX
  include KML
  include CONVERTER

  class GpxKml
    def self.gpx_to_kml(gpx, destination_path)
      CONVERTER::Converter.gpx_to_kml(gpx, destination_path)
    end

    def self.kml_to_gpx(kml, destination_path)
      CONVERTER::Converter.kml_to_gpx(kml, destination_path)
    end

    def self.kml?(kml)
      kml.is_a?(KML::Kml) && kml.kml?
    end

    def self.gpx?(gpx)
      gpx.is_a?(GPX::Gpx) && gpx.gpx?
    end

    def self.new_kml(file_path)
      KML::Kml.new(file_path)
    end

    def self.new_gpx(file_path)
      GPX::Gpx.new(file_path)
    end
  end
end
