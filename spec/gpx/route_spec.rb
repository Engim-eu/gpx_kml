require 'rspec'

RSpec.describe 'Route' do

  let(:gpx) { GPXKML::Gpx.new("#{__dir__}/../test_files/test_route.gpx") }
  let(:route0) { gpx.routes[0] }
  let(:route1) { gpx.routes[1] }

  it 'returns the name of the route if present' do
    expect(route1.name).to eq('ROUTE ZONA 2')
    expect(route0.name).to eq('route 1')
  end

  it 'returns the number of points if present' do
    expect(route0.points.length).to be 0
    expect(route1.points.length).to be 3
  end

  it 'returns the description of the route if present' do
    expect(route0.description).to eq('Che bella route, wow!')
    expect(route1.description).to eq('')
  end

  it 'returns the link of the route if present' do
    expect(route0.link).to eq('https://www.google.com')
    expect(route1.link).to eq('')
  end

  it 'returns the number of the route if present' do
    expect(route1.number).to eq('5')
    expect(route0.number).to eq('')
  end
end
