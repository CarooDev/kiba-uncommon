# kiba-uncommon

`kiba-uncommon` is a gem that provides ETL connectivity to and from Zuora with the goal of being easily extensible for future 3rd parties and their integrations. `kiba-uncommon` seeks to provide the necessary sources, transforms, and destinations we find to be common to our business needs at Snacknation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kiba-uncommon'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kiba-install

## Usage

#### CSV to CSV workflow demo
One of the simplest examples to get started with is a CSV to CSV identity transform(returns the data unchanged):
```ruby
job = Kiba.parse do
  source Kiba::Uncommon::Sources::CsvSource, 'test_data.csv'
  transform Kiba::Uncommon::Transforms::IdentityTransform
  destination Kiba::Uncommon::Destinations::CsvDestination, "output.csv"
end
Kiba.run(job)
```
this will effectively copy the CSV file `test_data.csv` to `output.csv`, but it should help demonstrate the Source, Transform, Destination Pipeline:

1. `Kiba::Uncommon::Sources::CsvSource` reads the data from the source. in this case its a CSV file, but could be a DB or another source.
2. `Kiba::Uncommon::Transforms::IdentityTransform` provides a transform that simply passes the data through unchanged. you can use this as a template for your custom transforms.
3. `Kiba::Uncommon::Destinations::CsvDestination` provides a destination for the final data. you can specify multiple destinations per job, should you want to push it to multiple destinations. in this demonstration, it will simply write to another CSV.

#### Zuora account to CSV

Here is a job that will source Zuora Account data and export it to CSV:
```ruby
job = Kiba.parse do
  source Kiba::Uncommon::Sources::ZOQLSource, z_client, 'select Id, Name, Status from Account'
  destination Kiba::Uncommon::Destinations::CsvDestination, 'zuora_to_csv_output.csv'
end
Kiba.run(job)
```

#### Filtering for Duplicates

There is a sample file in the `samples` directory named `zuora_dupes.etl` which contains a Kiba Job similar to the one above, but with one minor difference of adding this transform:
```ruby
transform RegexMatcher, 'name', /\(dupe\)/i
```

this calls a transform named `RegexMatcher` that will only allow a row to be returned if it matches the regex provided. in this case, we only want to return the Accounts that have the string `(dupe)` in the Account name.

##### running the the .etl file
In order to run the kiba-uncommon .etl file, you'll need to set up a `.env` file in your project.
```
ZUORA_USERNAME=
ZUORA_PASSWORD=
USE_ZUORA_SANDBOX=true
```
Once thats filled out, change directory to the `samples/` directory: `cd samples` and  run `kiba zuora_dupes.etl`

this may take a few minutes to run depending on your Account Table size, but once its done, you should be able to find all Accounts with `(dupe)` in the Account name inside the `zuora_to_csv_output.csv`.
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SnackNation/kiba-uncommon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kiba::Uncommon project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/kiba-uncommon/blob/master/CODE_OF_CONDUCT.md).
