require 'rspec'

RSpec.describe 'Converter' do
  let(:gpx) { GPXKML::Gpx.new("#{__dir__}/test_files/test.gpx") }
  let(:kml) { GPXKML::Kml.new("#{__dir__}/test_files/test.kml") }

  it 'converts gpx into kml' do
    new_file = CONVERTER::Converter.gpx_to_kml(gpx, "#{__dir__}/test_files")
    f = File.open(new_file)
    f2 = File.open("#{__dir__}/test_files/preconverted_gpx.kml")
    expect(f.read).to eq(f2.read)
    f.close
    f2.close
    File.delete(new_file)
  end

  it 'converts kml into gpx' do
    new_file = CONVERTER::Converter.kml_to_gpx(kml, "#{__dir__}/test_files")
    f = File.open(new_file)
    f2 = File.open("#{__dir__}/test_files/preconverted_kml.gpx")
    expect(f.read).to eq(f2.read)
    f.close
    f2.close
    File.delete(new_file)
  end
end
