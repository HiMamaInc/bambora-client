# Bambora

[![CircleCI](https://circleci.com/gh/HiMamaInc/bambora-client.svg?style=svg)](https://circleci.com/gh/HiMamaInc/bambora-client)

The official Bambora Ruby library is not thread-safe. This means you will run into errors when using it with Sidekiq or
Puma. This gem is a thread-safe client for the Bambora and Beanstream APIs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bambora-client'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install bambora-client
```

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

You can also initilze a client with a sub-merchant-id:

```ruby
client = Bambora::Client.new(
  api_key: ENV.fetch('BAMBORA_API_KEY'),
  merchant_id: ENV.fetch('BAMBORA_MERCHANT_ID'),
  sub_merchant_id: 'submerchantid',
)
```

### Profiles

*Summary*: Payment profiles store confidential payment information. Transactions can be processed against profiles.
*Bambora Docs*: <https://dev.na.bambora.com/docs/guides/payment_profiles/>

#### Create a Profile

```ruby
client.profiles.create(
  {
    language: 'en',
    comments: 'hello',
    card: {
      name: 'Hup Podling',
      number: '4030000010001234',
      expiry_month: '12',
      expiry_year: '23',
      cvd: '123',
    },
  },
)
# => {
#       :code => 1,
#       :message => "Operation Successful"
#       :customer_code: "02355E2e58Bf488EAB4EaFAD7083dB6A",
#    }
```

## Delete a Profile

```ruby
client.profiles.delete(customer_code: '02355E2e58Bf488EAB4EaFAD7083dB6A')
# => {
#       :code => 1,
#       :message => "Operation Successful"
#       :customer_code: "02355E2e58Bf488EAB4EaFAD7083dB6A",
#    }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/HiMamaInc/bambora-client>. This project is
intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bambora project’s codebases, issue trackers, chat rooms and mailing lists is expected to
follow the [code of conduct](https://github.com/HiMamaInc/bambora/blob/master/CODE_OF_CONDUCT.md).
