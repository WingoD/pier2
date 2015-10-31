# Pier2

Pier2 abstracts an importer to create dereived classes which import from a spreadsheet file (.xls, xlsx, etc (whatever roo supports)) and automatically imports into an existing ActiceRecord class.

[![Code Climate](https://img.shields.io/codeclimate/github/wwalker/pier2.svg?style=flat-square)](https://codeclimate.com/github/wwalker/pier2) 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pier2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pier2

Install from source

    $ rake gem
    $ gem install ...

## Usage

# Preparation
Create a new class

```
require pier2
class ImportInvoice < Pier2
  def initialize
    super
    ar_class(Invoice)
    id_column("IdNum")
    required_columns(%w(customer_id, date, amount))
    protected_columns(%w( balance ))
    immutable_columms(%w(customer_id))
    column_name_mapping( { 'Given Name' => 'first_name', 'Sir Name' => 'last_name' } )
  end
end
```

# Import a file directly into the database

```
ImportInvoice.direct_import("may_invoices.xslx")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/pier2/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

