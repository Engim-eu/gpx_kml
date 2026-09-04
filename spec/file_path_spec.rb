require 'rspec'
require 'tmpdir'

RSpec.describe 'File paths' do
  around do |example|
    Dir.mktmpdir { |dir| @dir = dir and example.run }
  end

  def copy(source, name)
    path = File.join(@dir, name)
    FileUtils.cp("#{__dir__}/test_files/#{source}", path)
    path
  end

  it 'reads a gpx whose extension is uppercase' do
    gpx = GPXKML::Gpx.new(copy('test.gpx', 'TRACK.GPX'))
    expect(gpx.valid?).to be true
    expect(gpx.points_length).to eq 2
  end

  it 'reads a kml whose extension is uppercase' do
    kml = GPXKML::Kml.new(copy('test.kml', 'ZONE.KML'))
    expect(kml.valid?).to be true
    expect(kml.points.length).to eq 2
  end

  it 'reads a gpx that carries no extension at all' do
    expect(GPXKML::Gpx.new(copy('test.gpx', 'track')).valid?).to be true
  end

  it 'decides from the content, not from the extension' do
    expect(GPXKML::Gpx.new(copy('test.kml', 'zone.gpx')).gpx?).to be false
    expect(GPXKML::Kml.new(copy('test.gpx', 'track.kml')).kml?).to be false
  end

  it 'returns an empty object for a path that is not a file' do
    expect(GPXKML::Gpx.new(File.join(@dir, 'missing.gpx')).valid?).to be false
    expect(GPXKML::Kml.new(File.join(@dir, 'missing.kml')).valid?).to be false
    expect(GPXKML::Gpx.new(@dir).valid?).to be false
  end
end
