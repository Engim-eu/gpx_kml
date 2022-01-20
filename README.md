# GpxKml

[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](http://www.gnu.org/licenses/lgpl-3.0) [![Coverage: %](https://img.shields.io/badge/Code%20coverage-100%25-green.svg)](#coverage)

This gem adds the capability to convert GPS Exchange Format (GPX) files to Keyhole Markup Language (KML) files and viceversa

## Before using

Please take note that this only converts essentials data for the gpx and kml files compatibility.
However the gem doesn't just include the converter, it also transforms gpx files and kml files (only their track/route/point parts) into a Gpx/Kml instance, which could be useful for new forks or other uses.
Just dig in deep, tests are present for everything you need.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gpx_kml'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gpx_kml

## Usage

To use it just ```require 'gpx_kml'``` in the script you need the converter and perform the following actions:
<br>
Create an instance of the file you want to convert as follows:
- ```gpx = GPXKML::GpxKml.new_gpx('file_path')``` for a gpx file
- ```kml = GPXKML::GpxKml.new_kml('file_path')``` for a kml file
<br><br>

Now: you may want to check if the file you imported is actually a gpx or a kml.<br>
You can do that by usign the ```gpx?``` &  ```kml?``` functions on the instance you just created:
- ```GPXKML::GpxKml.gpx?(gpx)```
- ```GPXKML::GpxKml.kml?(kml)```

Note: this step is optional since the conversions method below do the same thing inside of themselves, but this method could turn out to be useful.
<br><br>
Now you can actually convert the instance to create the new file needed.<br>
The function will return the entire path to the file just created!
- ```path_of_the_new_file = GPXKML::GpxKml.kml_to_gpx('gpx', 'destination_path')```
- ```path_of_the_new_file = GPXKML::GpxKml.gpx_to_kml('kml', 'destination_path')```

IMPORTANT : ```destination_path``` must be a directory

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Engim-eu/gpx_kml. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/gpx_kml/blob/master/CODE_OF_CONDUCT.md).

## Coverage

Coverage can be checked running `rake spec`. This command will generate the coverage files needed.

## Code of Conduct

Everyone interacting in the GpxKml project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/gpx_kml/blob/master/CODE_OF_CONDUCT.md).
