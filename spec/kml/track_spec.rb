require 'rspec'

RSpec.describe 'Track' do
  let(:track) { GPXKML::Kml.new("#{__dir__}/../test_files/test.kml").tracks[0] }
  let(:point0t0p) { track.points[0] }

  it 'retrieves the name of the track' do
    expect(track.name).to eq('ZONA 1')
  end

  it 'retrieves the correct number of points' do
    expect(track.points.length).to be 720
  end

  it 'retrieves the author of the document' do
    expect(track.author).to eq('Engim Srl')
  end

  it 'retrieves the document link' do
    expect(track.link).to eq('https://www.engim.eu')
  end
end
