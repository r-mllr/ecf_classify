# ECF Classify

[![Gem Version](https://badge.fury.io/rb/ecf_classify.svg)](https://badge.fury.io/rb/ecf_classify)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ecf_classify`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

### As a command line tool

You can install `ecf_classify` with the ruby package manager

```bash
gem install ecf_classify
```

### As a Ruby module

Add this line to your application's Gemfile:

```ruby
gem 'ecf_classify'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ bundle install 
    $ rake install 

## Usage

### General 
```
ecf_classify commands:
  ecf_classify --version         # print the version
  ecf_classify groups [FILE]     # Classifies protein sequences into ECF groups
  ecf_classify help [COMMAND]    # Describe available commands or one specific command
  ecf_classify subgroups [FILE]  # Classifies protein sequences into ECF subgroups

Options:
  -h, [--help], [--no-help]
```

### Groups

```
Usage:
  ecf_classify groups [FILE]

Options:
  -p, [--probabilities=PROBABILTIES]
  -h, [--help], [--no-help]

Classifies protein sequences into ECF groups

```

### Subgroups

```
Usage:
  ecf_classify subgroups [FILE]

Options:
  -p, [--probabilities=PROBABILTIES]
  -h, [--help], [--no-help]

Classifies protein sequences into ECF subgroups

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

--> This will not be done before submission
To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/r-mllr/ecf_classify.

## Publication

Please cite:

(unpublished) Casas-Pastor D., Müller R.R., Jaenicke S., Brinkrolf K., Mascher T., Goesmann A., Fritz G. [Expansion and re-classification of the extracytoplasmic function (ECF) σ factor family]()

## License

The gem is available as open source under the terms of the [GPL-3](https://opensource.org/licenses/GPL-3.0).
