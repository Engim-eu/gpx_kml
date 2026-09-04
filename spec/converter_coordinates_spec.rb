require 'rspec'

RSpec.describe 'Converter coordinates' do
  let(:kml) { GPXKML::Kml.new("#{__dir__}/test_files/test_coordinates.kml") }
  let(:gpx) do
    path = CONVERTER::Converter.kml_to_gpx(kml, "#{__dir__}/test_files")
    content = File.read(path)
    File.delete(path)
    content
  end
  let(:document) { Nokogiri::XML(gpx).tap(&:remove_namespaces!) }

  it 'writes the coordinates of a kml whose elevations are integers' do
    expect(gpx).not_to include 'lat=""'
    expect(gpx).not_to include 'lon=""'
    expect(document.xpath('//wpt').map { |p| [p['lon'], p['lat']] }).to eq [['9.185982', '45.465422']]
    expect(document.xpath('//trkpt').map { |p| [p['lon'], p['lat']] })
      .to eq [['10.9672', '44.6598'], ['-74.006', '40.7128'], ['12', '42']]
    expect(document.xpath('//rtept').map { |p| [p['lon'], p['lat']] })
      .to eq [['10.9672', '-44.6598'], ['10.97', '-44.66'], ['10.9672', '-44.6598']]
  end

  it 'keeps the elevation it read' do
    expect(document.xpath('//wpt/ele').map(&:text)).to eq ['0']
    expect(document.xpath('//rtept/ele').map(&:text)).to eq %w[123 123 123]
  end

  it 'leaves out the points it could not read instead of writing empty ones' do
    expect(document.xpath('//trkpt').length).to eq 3
    expect(kml.tracks[0].points.length).to eq 4
  end

  it 'declares the GPX 1.1 namespace' do
    expect(Nokogiri::XML(gpx).root.namespace.href).to eq 'http://www.topografix.com/GPX/1/1'
  end
end
