require 'rspec'

RSpec.describe 'Point' do
  include GPXKML
  let(:kml) { GPXKML::Kml.new("#{__dir__}/../test_files/test.kml") }
  let(:kml_route) { GPXKML::Kml.new("#{__dir__}/../test_files/test_route.kml") }
  let(:track) { kml.tracks[0] }
  let(:route) { kml_route.routes[0] }
  let(:point0t0p) { track.points[0] }
  let(:point0k0p) { kml.points[0] }
  let(:point0k1p) { kml.points[1] }
  let(:point0r0p) { route.points[0] }
  let(:point1k0p) { kml_route.points[0] }
  let(:point1k1p) { kml_route.points[1] }

  context 'retrieval of point information' do
    it 'retrieves longitude of the point' do
      expect(point0k0p.latitude).to eq '11.03294'
      expect(point0k1p.latitude).to eq '11.03294'
      expect(point0t0p.latitude).to eq '11.883245'
      expect(point1k0p.latitude).to eq '11.03294'
      expect(point1k1p.latitude).to eq '11.03294'
      expect(point0r0p.latitude).to eq '11.883245'
    end

    it 'retrieves latitude of the point' do
      expect(point0k0p.longitude).to eq '49.01324'
      expect(point0k1p.longitude).to eq '49.01324'
      expect(point0t0p.longitude).to eq '46.059044'
      expect(point1k0p.longitude).to eq '49.01324'
      expect(point1k1p.longitude).to eq '49.01324'
      expect(point0r0p.longitude).to eq '46.059044'
    end

    it 'retrieves elevation of the point' do
      expect(point0k0p.elevation).to eq '306.8'
      expect(point0k1p.elevation).to be_nil
      expect(point0t0p.elevation).to eq '590.9'
      expect(point1k0p.elevation).to eq '306.8'
      expect(point1k1p.elevation).to be_nil
      expect(point0r0p.elevation).to eq '590.9'
    end

    it 'retrieves the nearest name from his ancestors' do
      expect(point0k0p.name).to eq 'ZONA 1'
      expect(point0k1p.name).to eq 'ZONA 1'
      expect(point0t0p.name).to eq 'ZONA 1'
      expect(point1k0p.name).to eq 'ZONA 2'
      expect(point1k1p.name).to eq 'ZONA 2'
      expect(point0r0p.name).to eq 'ZONA 2'
    end
  end

  context 'check correct inheritance' do
    it 'returns its father' do
      expect(point0k0p.father).to be kml
      expect(point0k1p.father).to be kml
      expect(point0t0p.father).to be track
      expect(point1k0p.father).to be kml_route
      expect(point1k1p.father).to be kml_route
      expect(point0r0p.father).to be route
    end

    it 'returns the document author if not a route or track point' do
      expect(point0k0p.author).to eq('Engim Srl')
      expect(point0k1p.author).to eq('Engim Srl')
      expect(point0t0p.author).to be_nil
      expect(point1k0p.author).to eq('Engim Srl')
      expect(point1k1p.author).to eq('Engim Srl')
      expect(point0r0p.author).to be_nil
    end

    it 'returns the document link if not a route or track point' do
      expect(point0k0p.link).to eq('https://www.engim.eu')
      expect(point0k1p.link).to eq('https://www.engim.eu')
      expect(point0t0p.link).to be_nil
      expect(point1k0p.link).to eq('https://www.engim.eu')
      expect(point1k1p.link).to eq('https://www.engim.eu')
      expect(point0r0p.link).to be_nil
    end
  end
end
