# Bambora

The official Bambora Ruby library is not thread-safe. This means you will run into errors when using it with Sidekiq or Puma. This gem is a thread-safe client for the Bambora and Beanstream APIs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bambora'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bambora

## Usage

You can initilize the client by passing a hash to it, or by passing a block.

```ruby
client = Bambora::Client.new(
  api_key: ENV.fetch('BAMBORA_API_KEY'),
  merchant_id: ENV.fetch('BAMBORA_MERCHANT_ID'),
)
```

```ruby
client = Bambora::Client.new do |c|
  c.api_key = ENV.fetch('BAMBORA_API_KEY')
  c.merchant_id = ENV.fetch('BAMBORA_MERCHANT_ID')
end
```

### Sub-Merchant ID

You can also initilze a client with a sub-merchant-id:

```ruby
client = Bambora::Client.new(
  api_key: ENV.fetch('BAMBORA_API_KEY'),
  merchant_id: ENV.fetch('BAMBORA_MERCHANT_ID'),
  sub_merchant_id: 'submerchantid',
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/HiMamaInc/bambora. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bambora project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/HiMamaInc/bambora/blob/master/CODE_OF_CONDUCT.md).
