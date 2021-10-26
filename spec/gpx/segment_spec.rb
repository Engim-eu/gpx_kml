require 'rspec'

RSpec.describe 'Segment' do

  let(:gpx) { GPXKML::Gpx.new("#{__dir__}/../test_files/test.gpx") }
  let(:segment1p0) { gpx.tracks[1].segments[0] }
  let(:segment0p0) { gpx.tracks[0].segments[0] }
  let(:segment0p1) { gpx.tracks[0].segments[1] }
  let(:tracks) { gpx.tracks }


  it 'returns the correct number of points' do
    expect(segment1p0.points.length).to be 3
    expect(segment0p0.points.length).to be 0
    expect(segment0p1.points.length).to be 0
  end

  it 'returns the correct track' do
    expect(segment1p0.track).to eq tracks[1]
    expect(segment0p0.track).to eq tracks[0]
    expect(segment0p1.track).to eq tracks[0]
  end
end
