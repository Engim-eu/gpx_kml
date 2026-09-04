require 'rspec'

RSpec.describe 'Gpx point coordinates' do
  let(:gpx) { GPXKML::Gpx.new("#{__dir__}/../test_files/test_no_coordinates.gpx") }
  let(:kml) do
    path = CONVERTER::Converter.gpx_to_kml(gpx, "#{__dir__}/../test_files")
    content = File.read(path)
    File.delete(path)
    content
  end
  let(:document) { Nokogiri::XML(kml).tap(&:remove_namespaces!) }

  it 'tells a point with unusable coordinates from a usable one' do
    expect(gpx.points.map(&:valid?)).to eq [false, true]
    expect(gpx.tracks[0].segments[0].points.map(&:valid?)).to eq [false, true, false]
  end

  it 'leaves the unusable points out of the kml' do
    expect(document.xpath('//Point/coordinates').map(&:text)).to eq ['9.185982,45.465422']
    expect(document.xpath('//LineString/coordinates').map(&:text)).to eq ['10.9672,44.6598']
  end

  it 'never writes a coordinate made of separators alone' do
    expect(kml).not_to include '<coordinates>,'
    expect(kml).not_to include ', ,'
  end

  context 'a track with no usable point at all' do
    let(:gpx) { GPXKML::Gpx.new("#{__dir__}/../test_files/test.gpx") }

    it 'is left out instead of becoming an empty LineString' do
      expect(gpx.tracks.length).to eq 2
      expect(gpx.tracks[0].segments.flat_map(&:points)).to be_empty
      expect(document.xpath('//LineString').length).to eq 1
      expect(kml).not_to include '<coordinates/>'
    end
  end
end
