# frozen_string_literal: true

require 'rspec'

RSpec.describe 'Gpx' do
  include GPXKML

  let(:gpx) { GPXKML::Gpx.new("#{__dir__}/test_files/test.gpx") }
  let(:not_a_gpx) { GPXKML::Gpx.new("#{__dir__}/test_files/test.kml") }
  let(:empty_gpx) { GPXKML::Gpx.new("#{__dir__}/test_files/test_alt.gpx") }
  let(:invalid_gpx) { GPXKML::Gpx.new("#{__dir__}/test_files/test_invalid.gpx") }

  context 'validity checks' do

    it 'checks if the file is a gpx' do
      expect(gpx.gpx?).to be true
      expect(not_a_gpx.gpx?).to be false
    end

    it 'checks the absence of routes' do
      expect(gpx.routes?).to be false
    end

    it 'checks the presence of tracks' do
      expect(gpx.tracks?).to be true
    end

    it 'checks the absence of tracks' do
      expect(invalid_gpx.tracks?).to be false
    end

    it 'checks the presence of points' do
      expect(gpx.points?).to be true
    end

    it 'checks the validity of a file' do
      expect(gpx.valid?).to be true
    end

    it 'checks the invalidity of a file' do
      expect(invalid_gpx.valid?).to be false
    end
  end

  context 'already ok, do not redo' do
    it 'returns the name of the author of the gpx' do
      expect(gpx.author).to eq('Engim Srl')
    end

    it 'returns the link of the gpx' do
      expect(gpx.link).to eq('https://www.engim.eu')
    end
  end

  context 'retrieval of information from the gpx' do
    it 'returns the name of the gpx' do
      expect(gpx.name).to eq('ZONA 2')
    end

    it 'does not return the name if the file is not valid', focus: true do
      expect(invalid_gpx.name).to be_nil
    end

    it 'returns nil for parameters if the file is not valid', focus: true do
      expect(invalid_gpx.tracks).to be_nil
      expect(invalid_gpx.routes).to be_nil
      expect(invalid_gpx.points).to be_nil
      expect(invalid_gpx.points_length).to be_nil
      expect(invalid_gpx.tracks_length).to be_nil
      expect(invalid_gpx.routes_length).to be_nil
      expect(invalid_gpx.file_name).to be_nil
    end

    it 'returns the description of the gpx' do
      expect(gpx.description).to eq('Description')
    end

    it 'returns the name of the track/route/waypoint if no name is found in metadata' do
      expect(empty_gpx.name).to eq('TRACK ZONA 2')
    end

    it 'returns the number of tracks in the gpx' do
      expect(gpx.tracks_length).to be 2
    end

    it 'returns the number of points in the gpx' do
      expect(gpx.points_length).to be 2
    end

    it 'returns 0 if no route is present' do
      expect(gpx.routes_length).to be 0
    end

    it 'returns the track name' do
      expect(gpx.tracks[0].name).to eq('track 1')
    end

  end

  # TODO: Rewrite all tests!!!
end
