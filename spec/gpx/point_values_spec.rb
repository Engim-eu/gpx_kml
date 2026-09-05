require 'rspec'

RSpec.describe 'Gpx point values' do
  let(:gpx) { GPXKML::Gpx.new("#{__dir__}/../test_files/test_dirty_values.gpx") }
  let(:kml) do
    path = CONVERTER::Converter.gpx_to_kml(gpx, "#{__dir__}/../test_files")
    content = File.read(path)
    File.delete(path)
    content
  end
  let(:coordinates) do
    Nokogiri::XML(kml).tap(&:remove_namespaces!).xpath('//coordinates').map(&:text)
  end

  it 'drops the whitespace a document may carry around a coordinate' do
    expect(gpx.points[0].longitude).to eq '9.185982'
    expect(gpx.points[0].latitude).to eq '45.465422'
    expect(gpx.tracks[0].segments[0].points[0].latitude).to eq '44.6598'
  end

  it 'leaves out an elevation that is not a number' do
    expect(gpx.points[0].elevation).to be_empty
    expect(gpx.tracks[0].segments[0].points[0].elevation).to be_empty
    expect(gpx.tracks[0].segments[0].points[1].elevation).to eq '123'
  end

  it 'keeps the point: a broken elevation is not a reason to lose the position' do
    expect(gpx.points[0]).to be_valid
    expect(gpx.tracks[0].segments[0].points.map(&:valid?)).to eq [true, true]
  end

  it 'writes tuples a kml reader can actually split apart' do
    expect(coordinates).to eq ['9.185982,45.465422', '10.9672,44.6598 10.97,44.66,123']
    expect(coordinates.join).not_to include ' ,'
    expect(coordinates.join).not_to include ', '
  end
end
