#!/usr/bin/rake -T

require 'puppetlabs_spec_helper/rake_tasks'

# Lint Material
begin
  require 'puppet-lint/tasks/puppet-lint'

  PuppetLint.configuration.send("disable_80chars")
  PuppetLint.configuration.send("disable_variables_not_enclosed")
  PuppetLint.configuration.send("disable_class_parameter_defaults")
rescue LoadError
  puts "WARNING: Can't run lint tests. Could not find puppet-lint gem"
end
