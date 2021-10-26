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
    def self.gpx_to_kml(file_path, destination_path)
      CONVERTER::Converter.gpx_to_kml(file_path, destination_path)
    end

    def self.kml_to_gpx(file_path, destination_path)
      CONVERTER::Converter.kml_to_gpx(file_path, destination_path)
    end
  end
end
