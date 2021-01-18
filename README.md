# ECF Classify

[![Gem Version](https://badge.fury.io/rb/ecf_classify.svg)](https://badge.fury.io/rb/ecf_classify)

A small software pipeline for the discovery of potentially new ECF σ factors and the prediction of their functionality with regards to the new classification schema ([Casas-Pastor et al.](https://doi.org/10.1093/nar/gkaa1229)).

## Prerequisite

Please install [hmmer 3](http://hmmer.org/documentation.html).
Furthermore, you need to install the following python packages

```
# requirements.txt
numpy
biopython==1.78
```

`python3 -m pip install -r requirements.txt`

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

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/r-mllr/ecf_classify.

## Publication / How to cite

Please cite:

Casas-Pastor D, Müller RR, Jaenicke S, Brinkrolf K, Becker A, Buttner MJ, Gross CA, Mascher T, Goesmann A, Fritz G. Expansion and re-classification of the extracytoplasmic function (ECF) σ factor family. Nucleic Acids Res. 2021 Jan 4:gkaa1229. doi: 10.1093/nar/gkaa1229. Epub ahead of print. PMID: 33398323.

## License

The gem is available as open source under the terms of the [GPL-3](https://opensource.org/licenses/GPL-3.0).
