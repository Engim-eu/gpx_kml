require 'rspec'

RSpec.describe 'Point coordinates' do
  let(:kml) { GPXKML::Kml.new("#{__dir__}/../test_files/test.kml") }
  let(:doc) do
    Nokogiri::XML('<kml><Document><Placemark><Point><coordinates/></Point></Placemark></Document></kml>')
  end
  let(:node) { doc.at_xpath('//Point') }

  def point(coord)
    KML::Point.new coord, kml, node
  end

  context 'accepts every coordinate tuple KML allows' do
    it 'accepts an integer elevation' do
      expect(point('9.185982,45.465422,0')).to be_valid
      expect(point('9.185982,45.465422,0').longitude).to eq '9.185982'
      expect(point('9.185982,45.465422,0').latitude).to eq '45.465422'
      expect(point('9.185982,45.465422,0').elevation).to eq '0'
      expect(point('9.185982,45.465422,123')).to be_valid
    end

    it 'accepts negative longitudes and latitudes' do
      expect(point('-9.185982,45.465422').longitude).to eq '-9.185982'
      expect(point('9.185982,-45.465422').latitude).to eq '-45.465422'
      expect(point('-74.006,40.7128,0')).to be_valid
    end

    it 'accepts integer longitudes and latitudes' do
      expect(point('12,42')).to be_valid
      expect(point('12,42').longitude).to eq '12'
      expect(point('12,42').latitude).to eq '42'
      expect(point('12,42').elevation).to be_nil
    end

    it 'accepts an explicit plus sign' do
      expect(point('+9.185982,+45.465422')).to be_valid
    end

    it 'keeps accepting the tuples it already accepted' do
      expect(point('9.185982,45.465422')).to be_valid
      expect(point('9.185982,45.465422,0.0')).to be_valid
      expect(point(' 9.185982,45.465422 ')).to be_valid
    end

    it 'preserves the coordinate exactly as written in the document' do
      expect(point('11.030,49.010,306.80').longitude).to eq '11.030'
      expect(point('11.030,49.010,306.80').latitude).to eq '49.010'
      expect(point('11.030,49.010,306.80').elevation).to eq '306.80'
    end
  end

  context 'rejects what is not a coordinate' do
    it 'rejects a tuple with too few or too many components' do
      expect(point('9.185982')).not_to be_valid
      expect(point('9.185982,45.465422,0,7')).not_to be_valid
      expect(point('')).not_to be_valid
    end

    it 'rejects non numeric components' do
      expect(point('abc,def')).not_to be_valid
      expect(point('9.185982,45.465422,abc')).not_to be_valid
      expect(point('0x10,45.465422')).not_to be_valid
    end

    it 'rejects coordinates outside the ranges KML defines' do
      expect(point('181,45.465422')).not_to be_valid
      expect(point('9.185982,91')).not_to be_valid
    end

    it 'leaves latitude and longitude nil when it rejects a tuple' do
      expect(point('abc,def').latitude).to be_nil
      expect(point('abc,def').longitude).to be_nil
    end
  end

  context 'a document whose coordinates carry an integer elevation' do
    let(:kml) { GPXKML::Kml.new("#{__dir__}/../test_files/test_coordinates.kml") }

    it 'reads the point' do
      expect(kml.points[0].latitude).to eq '45.465422'
      expect(kml.points[0].longitude).to eq '9.185982'
      expect(kml.points[0].elevation).to eq '0'
    end

    it 'reads the track, skipping only the malformed tuple' do
      expect(kml.tracks[0].points.count(&:valid?)).to eq 3
      expect(kml.tracks[0].points.map(&:latitude)).to eq ['44.6598', '40.7128', '42', nil]
    end

    it 'reads the route' do
      expect(kml.routes[0].points.count(&:valid?)).to eq 3
      expect(kml.routes[0].points[0].latitude).to eq '-44.6598'
    end
  end
end
