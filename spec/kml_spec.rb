# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Kml' do
  include GPXKML

  let(:kml) { GPXKML::Kml.new("#{__dir__}/test_files/test.kml") }

  context 'validity checks' do
    it 'checks the presence of tracks' do
      expect(kml.tracks?).to be true
    end

    it 'checks the absence of routes' do
      expect(kml.routes?).to be false
    end

    it 'checks the presence of points' do
      expect(kml.points?).to be true
    end

    it 'checks if the file is valid' do
      expect(kml.valid?).to be true
    end
  end

  context 'retrieval of information from the kml' do
    it 'returns the number of tracks in the kml' do
      expect(kml.tracks_length).to be 1
    end

    it 'returns the number of tracks in the kml' do
      expect(kml.routes_length).to be 0
    end

    it 'returns the number of tracks in the kml' do
      expect(kml.points_length).to be 2
      puts 'from here'
      GPXKML::GpxKml.kml_to_gpx("/home/angelo/attempt1/test.kml", '/home/angelo/attempt1')
      GPXKML::GpxKml.gpx_to_kml("/home/angelo/attempt1/test_route.gpx", '/home/angelo/attempt1')
    end
  end
end
