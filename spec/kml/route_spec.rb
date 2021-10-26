require 'rspec'

RSpec.describe 'Route' do
  let(:route) { GPXKML::Kml.new("#{__dir__}/../test_files/test_route.kml").routes[0] }
  let(:point0t0p) { route.points[0] }

  it 'retrieves the name of the track' do
    expect(route.name).to eq('ZONA 2')
  end

  it 'retrieves the correct number of points' do
    expect(route.points.length).to be 2
  end

  it 'retrieves the author of the document' do
    expect(route.author).to eq('Engim Srl')
  end

  it 'retrieves the document link' do
    expect(route.link).to eq('https://www.engim.eu')
  end
end
