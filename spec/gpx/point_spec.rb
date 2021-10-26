require 'rspec'

RSpec.describe 'Point' do
  let(:gpx) { GPXKML::Gpx.new("#{__dir__}/../test_files/test.gpx") }
  let(:segment0) { gpx.tracks[1].segments[0] }
  let(:point0) { segment0.points[0] }
  let(:point1) { segment0.points[1] }
  let(:point2) { segment0.points[2] }

  context 'general point' do
    it 'returns the correct name of the point if present' do
      expect(point0.name).to eq('point 1')
      expect(point1.name).to eq('')
      expect(point2.name).to eq('')
    end

    it 'returns the correct latitude and longitude' do
      expect(point0.latitude).to eq('46.075041')
      expect(point0.longitude).to eq('11.871986')
      expect(point1.latitude).to eq('46.04676')
      expect(point1.longitude).to eq('11.914161')
      expect(point2.latitude).to eq('46.046712')
      expect(point2.longitude).to eq('11.914186')
    end

    it 'returns the correct elevation if present' do
      expect(point0.elevation).to eq('764.3')
      expect(point1.elevation).to eq('335.0')
      expect(point2.elevation).to eq('')
    end

    it 'returns the correct link if present' do
      expect(point0.link).to eq('https://www.engim.eu/')
      expect(point1.link).to eq('')
      expect(point2.link).to eq('')
    end

    it 'returns the correct description if present' do
      expect(point0.description).to eq('')
      expect(point1.description).to eq('beautiful point')
      expect(point2.description).to eq('')
    end

  end

  context 'track points' do
    it 'returns the right segment' do
      expect(point0.father).to equal(segment0)
      expect(point0.father).to equal(segment0)
      expect(point0.father).to equal(segment0)
    end
  end

  context 'route points' do
    # TODO: redo route-point tests
    it 'returns the right route' do
      expect(point0.father).to equal(segment0)
      expect(point1.father).to equal(segment0)
      expect(point2.father).to equal(segment0)
    end
  end

  context 'gpx points' do
    # TODO: gpx points
  end
end
