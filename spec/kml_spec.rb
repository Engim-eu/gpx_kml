# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Kml' do
  include GPXKML

  let(:kml) { GPXKML::Kml.new("#{__dir__}/test_files/test.kml") }
  let(:not_a_kml) { GPXKML::Kml.new("#{__dir__}/test_files/test.gpx") }

  context 'validity checks' do

    it 'checks if the file is a kml' do
      expect(kml.kml?).to be true
      expect(not_a_kml.kml?).to be false
    end

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
    end
  end
end
