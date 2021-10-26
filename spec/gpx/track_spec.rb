require 'rspec'

RSpec.describe 'Track' do
  include GPXKML

  let(:gpx) { GPXKML::Gpx.new("#{__dir__}/../test_files/test.gpx") }
  let(:tracks) { gpx.tracks }

  it 'returns the track name if there is one' do
    expect(tracks[0].name).to eq('track 1')
  end

  it 'returns the number of segments if present' do
    expect(tracks[0].segments.length).to be 2
    expect(tracks[1].segments.length).to be 1
  end

  it 'returns the description of the track if present' do
    expect(tracks[0].description).to eq('Che bella traccia, wow!')
    expect(tracks[1].description).to eq('')
  end

  it 'returns the link of the track if present' do
    expect(tracks[0].link).to eq('https://www.google.com')
    expect(tracks[1].link).to eq('')
  end

  it 'returns the number of the track if present' do
    expect(tracks[1].number).to eq('5')
    expect(tracks[0].number).to eq('')
  end
end
