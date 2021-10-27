# GpxKml

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/gpx_kml`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Before using

Please take note that this only converts essentials data for the gpx and kml files compatibility.
However the gem doesn't just include the converter, it also transforms gpx files and kml files (only their track/route/point parts) into a Gpx/Kml file, which could be useful for a new fork or other uses.
Just dig in deep, tests are present for everything you need, except the mere conversion.

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

To use it just ```require 'gpx_kml'``` in the script you need the converter and use either one of the following two functions:

- ```GPXKML::GpxKml.kml_to_gpx('file_path', 'destination_path')```
- ```GPXKML::GpxKml.gpx_to_kml('file_path', 'destination_path')```

Note: destination_path must be a directory

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Engim-eu/gpx_kml. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/gpx_kml/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the GpxKml project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/gpx_kml/blob/master/CODE_OF_CONDUCT.md).
