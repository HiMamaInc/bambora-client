# frozen_string_literal: true
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bambora/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'bambora-client'
  spec.version       = Bambora::Client::VERSION
  spec.authors       = ['Cassidy K']
  spec.email         = ['hello@cassidy.codes', 'tech@himama.com']

  spec.summary       = 'A thread-safe client for the Bambora/Beanstream API.'
  spec.description   = 'The official beanstream-ruby gem is not thread-safe. This thread-safe client works in '\
                         'environments like Sidekiq and Puma.'
  spec.homepage      = 'https://github.com/HiMamaInc/bambora-client'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/HiMamaInc/bambora-client'
    spec.metadata['changelog_uri'] = 'https://github.com/HiMamaInc/bambora-client/releases'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4.6'

  spec.add_dependency 'excon', '< 1.0'
  spec.add_dependency 'faraday', '1.0.1'
  spec.add_dependency 'gyoku', '~> 1.0'
  spec.add_dependency 'multiparty', '~> 0'

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'pry', '~> 0.12.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.7'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.4.1'
  spec.add_development_dependency 'rubocop', '~> 0.74.0'
  spec.add_development_dependency 'webmock', '~> 3.7'
end
