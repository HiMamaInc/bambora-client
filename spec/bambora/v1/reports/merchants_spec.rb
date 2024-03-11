# frozen_string_literal: true

RSpec.describe Bambora::V1::Reports::Merchants do
  describe '.get' do
    context 'when passing nil' do
      it 'raises ArgumentError' do
        credentials = Bambora::Credentials.new(
          merchant_id: '372110000',
          reporting_passcode: '28840CEB9H9D3DFC24A445B7461FD8FG',
        )

        expect { described_class.get(nil, credentials: credentials) }.to(
          raise_error(ArgumentError),
        )
      end
    end

    context 'when passing a boolean' do
      it 'raises ArgumentError' do
        credentials = Bambora::Credentials.new(
          merchant_id: '372110000',
          reporting_passcode: '28840CEB9H9D3DFC24A445B7461FD8FG',
        )

        expect { described_class.get(true, credentials: credentials) }.to(
          raise_error(ArgumentError),
        )
      end
    end

    context 'when passing a symbol' do
      it 'raises ArgumentError' do
        credentials = Bambora::Credentials.new(
          merchant_id: '372110000',
          reporting_passcode: '28840CEB9H9D3DFC24A445B7461FD8FG',
        )

        expect { described_class.get(:symbol, credentials: credentials) }.to(
          raise_error(ArgumentError),
        )
      end
    end

    context 'when passing a number (float)' do
      it 'raises ArgumentError' do
        credentials = Bambora::Credentials.new(
          merchant_id: '372110000',
          reporting_passcode: '28840CEB9H9D3DFC24A445B7461FD8FG',
        )

        expect { described_class.get(1.0, credentials: credentials) }.to(
          raise_error(ArgumentError),
        )
      end
    end

    context 'when passing an array' do
      it 'raises ArgumentError' do
        credentials = Bambora::Credentials.new(
          merchant_id: '372110000',
          reporting_passcode: '28840CEB9H9D3DFC24A445B7461FD8FG',
        )

        expect { described_class.get([], credentials: credentials) }.to(
          raise_error(ArgumentError),
        )
      end
    end

    context 'when passing a hash' do
      it 'raises ArgumentError' do
        credentials = Bambora::Credentials.new(
          merchant_id: '372110000',
          reporting_passcode: '28840CEB9H9D3DFC24A445B7461FD8FG',
        )

        expect { described_class.get({}, credentials: credentials) }.to(
          raise_error(ArgumentError),
        )
      end
    end

    context 'when passing a number (integer), but the API request is not authenticated' do
      it 'raises Bambora::InvalidAuthenticationError' do
        WebMock
          .stub_request(:get, 'https://api.na.bambora.com/v1/reports/merchants/372110001')
          .with(
            headers: {
              'Authorization' => 'Passcode MzcyMTEwMDAwOjI4ODQwQ0VCOUg5RDNERkMyNEE0NDVCNzQ2MUZEOEZH',
              'Content-Type' => 'application/json',
            },
          )
          .to_return(
            headers: {
              'Content-Type' => 'application/json',
            },
            body: {
              code: 21,
              category: 4,
              message: 'Authentication failed',
            }.to_json,
          )

        credentials = Bambora::Credentials.new(
          merchant_id: '372110000',
          reporting_passcode: '28840CEB9H9D3DFC24A445B7461FD8FG',
        )

        expect { described_class.get(372_110_001, credentials: credentials) }.to(
          raise_error(Bambora::InvalidAuthenticationError),
        )
      end
    end

    context 'when passing a number (integer), but the API request is invalid' do
      it 'raises Bambora::InvalidRequestError' do
        WebMock
          .stub_request(:get, 'https://api.na.bambora.com/v1/reports/merchants/372110001')
          .with(
            headers: {
              'Authorization' => 'Passcode MzcyMTEwMDAwOjI4ODQwQ0VCOUg5RDNERkMyNEE0NDVCNzQ2MUZEOEZH',
              'Content-Type' => 'application/json',
            },
          )
          .to_return(
            headers: {
              'Content-Type' => 'application/json',
            },
            body: {
              Message: 'The request is invalid.',
            }.to_json,
          )

        credentials = Bambora::Credentials.new(
          merchant_id: '372110000',
          reporting_passcode: '28840CEB9H9D3DFC24A445B7461FD8FG',
        )

        expect { described_class.get(372_110_001, credentials: credentials) }.to(
          raise_error(Bambora::InvalidRequestError),
        )
      end
    end

    context 'when passing a number (integer), the API request is authenticated and valid' do
      it 'returns merchant data for the merchant' do
        WebMock
          .stub_request(:get, 'https://api.na.bambora.com/v1/reports/merchants/372110001')
          .with(
            headers: {
              'Authorization' => 'Passcode MzcyMTEwMDAwOjI4ODQwQ0VCOUg5RDNERkMyNEE0NDVCNzQ2MUZEOEZH',
              'Content-Type' => 'application/json',
            },
          )
          .to_return(
            headers: {
              'Content-Type' => 'application/json',
            },
            body: {
              data: [
                [
                  {
                    merchant_id: 372_110_001,
                    merchant_name: 'ABC Business',
                    website: '',
                    address: {
                      street_address: '700 Main Street',
                      province: 'New York',
                      country: 'United States',
                      postal_code: '82210',
                    },
                    merchant_status: {
                      status: 'Active',
                      state: 'Live',
                      live_date: '2024-01-01',
                      created_date: '2024-01-01',
                      authorized_date: '2024-01-05',
                      temp_disabled_date: '0001-01-01',
                      last_enabled_date: '0001-01-01',
                      disabled_date: '0001-01-01',
                    },
                    processor: {
                      processor_name: 'First Data',
                      currency: 'USD',
                    },
                    batch: {
                      batch_limit: 100_000.0,
                      batch_line_limit: 100_000.0,
                      eft_credit_lag: 3,
                    },
                    settlement: {
                      credit_lag: 0,
                    },
                    cards: {
                      mastercard_enabled: false,
                      visa_enabled: false,
                      amex_enabled: false,
                      discover_enabled: false,
                      diners_enabled: false,
                      jcb_enabled: false,
                      mastercard_debit_enabled: false,
                      visa_debit_enabled: false,
                    },
                    features: {
                      checkout_enabled: true,
                      payment_profile_enabled: false,
                      recurring_billing_enabled: true,
                      credit_card_batch_enabled: false,
                      eft_ach_enabled: true,
                      interac_online_enabled: false,
                      visa_src_enabled: false,
                    },
                  },
                ],
              ],
            }.to_json,
          )

        credentials = Bambora::Credentials.new(
          merchant_id: '372110000',
          reporting_passcode: '28840CEB9H9D3DFC24A445B7461FD8FG',
        )

        merchants = described_class.get(372_110_001, credentials: credentials)

        expect(merchants[:data][0].length).to eq(1)
        expect(merchants[:data][0][0][:merchant_id]).to eq(372_110_001)
        expect(merchants[:data][0][0][:merchant_name]).to eq('ABC Business')
      end
    end
  end

  describe '.get_all' do
    context 'when the API request is not authenticated' do
      it 'raises Bambora::InvalidAuthenticationError' do
        WebMock
          .stub_request(:get, 'https://api.na.bambora.com/v1/reports/merchants')
          .with(
            headers: {
              'Authorization' => 'Passcode MzcyMTEwMDAwOjI4ODQwQ0VCOUg5RDNERkMyNEE0NDVCNzQ2MUZEOEZH',
              'Content-Type' => 'application/json',
            },
          )
          .to_return(
            headers: {
              'Content-Type' => 'application/json',
            },
            body: {
              code: 21,
              category: 4,
              message: 'Authentication failed',
            }.to_json,
          )

        credentials = Bambora::Credentials.new(
          merchant_id: '372110000',
          reporting_passcode: '28840CEB9H9D3DFC24A445B7461FD8FG',
        )

        expect { described_class.get_all(credentials: credentials) }.to(
          raise_error(Bambora::InvalidAuthenticationError),
        )
      end
    end

    context 'when the API request is authenticated' do
      it 'returns merchant data for all merchants' do
        WebMock
          .stub_request(:get, 'https://api.na.bambora.com/v1/reports/merchants')
          .with(
            headers: {
              'Authorization' => 'Passcode MzcyMTEwMDAwOjI4ODQwQ0VCOUg5RDNERkMyNEE0NDVCNzQ2MUZEOEZH',
              'Content-Type' => 'application/json',
            },
          )
          .to_return(
            headers: {
              'Content-Type' => 'application/json',
            },
            body: {
              data: [
                [
                  {
                    merchant_id: 372_110_001,
                    merchant_name: 'ABC Business',
                    website: '',
                    address: {
                      street_address: '700 Main Street',
                      province: 'New York',
                      country: 'United States',
                      postal_code: '82210',
                    },
                    merchant_status: {
                      status: 'Active',
                      state: 'Live',
                      live_date: '2024-01-01',
                      created_date: '2024-01-01',
                      authorized_date: '2024-01-05',
                      temp_disabled_date: '0001-01-01',
                      last_enabled_date: '0001-01-01',
                      disabled_date: '0001-01-01',
                    },
                    processor: {
                      processor_name: 'First Data',
                      currency: 'USD',
                    },
                    batch: {
                      batch_limit: 100_000.0,
                      batch_line_limit: 100_000.0,
                      eft_credit_lag: 3,
                    },
                    settlement: {
                      credit_lag: 0,
                    },
                    cards: {
                      mastercard_enabled: false,
                      visa_enabled: false,
                      amex_enabled: false,
                      discover_enabled: false,
                      diners_enabled: false,
                      jcb_enabled: false,
                      mastercard_debit_enabled: false,
                      visa_debit_enabled: false,
                    },
                    features: {
                      checkout_enabled: true,
                      payment_profile_enabled: false,
                      recurring_billing_enabled: true,
                      credit_card_batch_enabled: false,
                      eft_ach_enabled: true,
                      interac_online_enabled: false,
                      visa_src_enabled: false,
                    },
                  },
                  {
                    merchant_id: 372_110_002,
                    merchant_name: 'XYZ Business',
                    website: '',
                    address: {
                      street_address: '769 1st Street',
                      province: 'New York',
                      country: 'United States',
                      postal_code: '54493',
                    },
                    merchant_status: {
                      status: 'Active',
                      state: 'Live',
                      live_date: '2024-02-01',
                      created_date: '2024-02-01',
                      authorized_date: '2024-02-05',
                      temp_disabled_date: '0001-01-01',
                      last_enabled_date: '0001-01-01',
                      disabled_date: '0001-01-01',
                    },
                    processor: {
                      processor_name: 'First Data',
                      currency: 'USD',
                    },
                    batch: {
                      batch_limit: 100_000.0,
                      batch_line_limit: 100_000.0,
                      eft_credit_lag: 3,
                    },
                    settlement: {
                      credit_lag: 0,
                    },
                    cards: {
                      mastercard_enabled: false,
                      visa_enabled: false,
                      amex_enabled: false,
                      discover_enabled: false,
                      diners_enabled: false,
                      jcb_enabled: false,
                      mastercard_debit_enabled: false,
                      visa_debit_enabled: false,
                    },
                    features: {
                      checkout_enabled: true,
                      payment_profile_enabled: false,
                      recurring_billing_enabled: true,
                      credit_card_batch_enabled: false,
                      eft_ach_enabled: true,
                      interac_online_enabled: false,
                      visa_src_enabled: false,
                    },
                  },
                ],
              ],
            }.to_json,
          )

        credentials = Bambora::Credentials.new(
          merchant_id: '372110000',
          reporting_passcode: '28840CEB9H9D3DFC24A445B7461FD8FG',
        )

        merchants = described_class.get_all(credentials: credentials)

        expect(merchants[:data][0][0][:merchant_id]).to eq(372_110_001)
        expect(merchants[:data][0][0][:merchant_name]).to eq('ABC Business')
        expect(merchants[:data][0][1][:merchant_id]).to eq(372_110_002)
        expect(merchants[:data][0][1][:merchant_name]).to eq('XYZ Business')
      end
    end
  end
end
