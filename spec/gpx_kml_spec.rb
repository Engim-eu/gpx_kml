# frozen_string_literal: true



RSpec.describe GPXKML::GpxKml do
  it 'has a version number' do
    expect(GPXKML::VERSION).to be '0.1.3'
  end

  it 'checks if the imported file is actually a gpx' do
    gpx = GPXKML::GpxKml.new_gpx("#{__dir__}/test_files/test.gpx")
    expect(gpx.is_a?(GPX::Gpx)).to be true
    expect(gpx.gpx?).to be true
  end

  it 'checks if the imported file is actually a kml' do
    kml = GPXKML::GpxKml.new_kml("#{__dir__}/test_files/test.kml")
    expect(kml.is_a?(KML::Kml)).to be true
    expect(kml.kml?).to be true
  end

  it 'create a new, valid gpx' do
    gpx = GPXKML::GpxKml.new_gpx("#{__dir__}/test_files/test.gpx")
    expect(gpx.is_a?(GPX::Gpx)).to be true
    expect(gpx.gpx?).to be true
    expect(gpx.valid?).to be true
  end

  it 'creates a new, valid kml' do
    kml = GPXKML::GpxKml.new_kml("#{__dir__}/test_files/test.kml")
    expect(kml.is_a?(KML::Kml)).to be true
    expect(kml.kml?).to be true
    expect(kml.valid?).to be true
  end

  it 'correctly converts gpx into kml' do
    gpx = GPXKML::GpxKml.new_gpx("#{__dir__}/test_files/test.gpx")
    expect(gpx.is_a?(GPX::Gpx)).to be true
    expect(gpx.gpx?).to be true
    expect(gpx.valid?).to be true
    filename = GPXKML::GpxKml.gpx_to_kml(gpx, "#{__dir__}/test_files")
    f = File.open(filename)
    f2 = File.open("#{__dir__}/test_files/preconverted_gpx.kml")
    expect(f.read).to eq(f2.read)
    f.close
    f2.close
    File.delete(filename)
  end

  it 'correctly converts kml into gpx' do
    kml = GPXKML::GpxKml.new_kml("#{__dir__}/test_files/test.kml")
    expect(kml.is_a?(KML::Kml)).to be true
    expect(kml.kml?).to be true
    expect(kml.valid?).to be true
    filename = GPXKML::GpxKml.kml_to_gpx(kml, "#{__dir__}/test_files")
    f = File.open(filename)
    f2 = File.open("#{__dir__}/test_files/preconverted_kml.gpx")
    expect(f.read).to eq(f2.read)
    f.close
    f2.close
    File.delete(filename)
  end
end
