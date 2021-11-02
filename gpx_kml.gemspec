require_relative 'lib/gpx_kml/version'

Gem::Specification.new do |spec|
  spec.name          = 'gpx_kml'
  spec.version       = GPXKML::VERSION
  spec.authors       = ['Angelo Terzi']
  spec.email         = ['info@engim.eu']

  spec.summary       = 'Gem to convert .gpx into .kml and back'
  spec.description   = 'This gem adds the capability to convert GPS Exchange Format (GPX) files to Keyhole Markup Language (KML) files and viceversa'
  spec.homepage      = 'https://www.github.com/engim-eu/gpx_kml'
  spec.licenses      = ['LGNU']
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['allowed_push_host'] = "https://rubygems.org"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://www.github.com/engim-eu/gpx_kml'
  spec.metadata['changelog_uri'] = 'https://www.github.com/engim-eu/gpx_kml/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Building tool
  spec.add_dependency 'rake', '~> 12.0'

  # XML parsing
  spec.add_dependency 'nokogiri', '~>1.12.0'

  # Gem testing
  spec.add_development_dependency 'rspec', '~>3.0'

  # spec.add_development_dependency 'factory_bot', '~>6.2'
  # factory_bot isn't really used
end
