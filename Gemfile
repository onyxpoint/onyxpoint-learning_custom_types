# watch the name, or RVM will flip out
if Gem::Version.new( RUBY_VERSION ) < Gem::Version.new( '1.9' )
  warn( "WARNING: ruby #{RUBY_VERSION} detected!" +
        " Any ruby version below 1.9 will have issues." )
  old_ruby = true
end

source 'https://rubygems.org'

# nice-to-have gems (for debugging)
group :debug do
  gem 'pry'
  gem 'pry-doc'
  if old_ruby
    warn( "WARNING: skipping pry-debugger because ruby #{RUBY_VERSION}!" )
  else
    gem 'pry-debugger'
  end
end

# mandatory gems
gem 'bundler'
gem 'rake'
gem 'puppet', '>= 3'
gem 'puppet-lint'
gem 'puppetlabs_spec_helper'
gem 'puppet_module_spec_helper'

#vim: set syntax=ruby:

