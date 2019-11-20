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

All `*_api_key` arguments are optional. If you do not pass these API keys in on initialization, you can pass them into their respective method calls.

```ruby
client = Bambora::Client.new(
  base_url: ENV.fetch('BAMBORA_BASE_URL'),
  merchant_id: ENV.fetch('BAMBORA_MERCHANT_ID'),
  sub_merchant_id: ENV.fetch('BAMBORA_SUB_MERCHANT_ID'),
)
```

The `client` can now initialize new classes for making requests to `/profiles`, `/payments`, etc.

```ruby
profiles = client.profiles(api_key: ENV.fetch('BAMBORA_PROFILES_API_KEY'))
profiles.delete(customer_code: '02355E2e58Bf488EAB4EaFAD7083dB6A')
```

### Profiles

*Summary*: Payment profiles store confidential payment information. Transactions can be processed against profiles.
*Bambora Docs*: <https://dev.na.bambora.com/docs/guides/payment_profiles/>

```ruby
client = Bambora::Client.new(...)
profiles = client.profiles(api_key: ENV.fetch('BAMBORA_PROFILES_API_KEY'))
```

Once the resource instance has been instantiated, actions can be made against the API.

#### Create a Profile

```ruby
profiles.create(
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
#      :code => 1,
#      :message => "Operation Successful",
#      :customer_code => "02355E2e58Bf488EAB4EaFAD7083dB6A",
#    }
```

#### Delete a Profile

```ruby
profiles.delete(customer_code: '02355E2e58Bf488EAB4EaFAD7083dB6A')
# => {
#      :code => 1,
#      :message => "Operation Successful",
#      :customer_code => "02355E2e58Bf488EAB4EaFAD7083dB6A",
#    }
```

### Payments

*Summary*: Process payments using Credit Card, Payment Profile, Legato Token, Cash, Cheque, Interac, Apple Pay, or
Android Pay.
*Bambora Docs*: <https://dev.na.bambora.com/docs/references/payment_APIs/>

```ruby
client = Bambora::Client.new(...)
payments = client.payments
```

#### Make A Payment

This is a lower level method that can be used to make a payment using any method. Below are some more specific and
high level convenience methods.

`create` is aliased as `make_payment` if you prefer syntax that reads more like a sentence.

```ruby
payments.create(
  {
    amount: 50,
    payment_method: 'card',
    card: {
      name: 'Hup Podling',
      number: '4504481742333',
      expiry_month: '12',
      expiry_year: '20',
      cvd: '123',
    },
  },
)
# => {
#      :id => "10000000",
#      :authorizing_merchant_id => 300000000,
#      :approved => "1",
#      :message_id => "1",
#      :message => "Approved",
#      :auth_code => "TEST",
#      :created => "2019-10-28T07:12:11",
#      :order_number => "10000000",
#      :type => "P",
#      :payment_method => "CC",
#      :risk_score => 0.0,
#      :amount => 50.0,
#      :custom => { :ref1 => "", :ref2 => "", :ref3 => "", :ref4 => "", :ref5 => "" },
#      :card =>
#        {
#          :card_type => "VI",
#          :last_fouri => "2333",
#          :address_match => 0,
#          :postal_result => 0,
#          :avs_result => "0",
#          :cvd_result => "1",
#          :avs => { :id => "U", :message => "Address information is unavailable.", :processed => false }
#        },
#      :links =>
#        [
#          { :rel => "void", :href => "https://api.na.bambora.com/v1/payments/10000000/void", :method => "POST" },
#          { :rel => "return", :href => "https://api.na.bambora.com/v1/payments/10000000/returns", :method => "POST" }
#        ]
#    }
```

##### Make A Payment With A Payment Profile

`create_with_payment_profile` is aliased as `make_payment_with_payment_profile` if you prefer syntax that reads more
like a sentence.

```ruby
payments.create_with_payment_profile(customer_code: '02355E2e58Bf488EAB4EaFAD7083dB6A', amount: 50)
# => {
#      :id => "10000000",
#      :authorizing_merchant_id => 300000000,
#      :approved => "1",
#      :message_id => "1",
#      :message => "Approved",
#      ...
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
