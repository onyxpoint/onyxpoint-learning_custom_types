#!/usr/bin/rake -T

require 'rubocop/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'

# Lint Material
begin
  require 'puppet-lint/tasks/puppet-lint'

  PuppetLint.configuration.send('disable_80chars')
  PuppetLint.configuration.send('disable_variables_not_enclosed')
  PuppetLint.configuration.send('disable_class_parameter_defaults')
rescue LoadError
  puts 'WARNING: Can not run lint tests. Could not find puppet-lint gem'
end

RuboCop::RakeTask.new

desc <<-EOM
  ** Run the Type and Provider walkthrough **

  ## Arguments ##

  :pry = Pass any value to have the code drop you into the Pry debugger at
         relevant breakpoints
EOM
task :Run_Walkthrough, [:pry] do |_t, args|
  args.with_defaults(
    :pry => false
  )

  Dir.chdir(File.dirname(__FILE__)) do
    module_dir = File.basename(Dir.pwd)
    if module_dir != 'learning_custom_types'
      fail "You must name your module 'learning_custom_types' instead of '#{module_dir}'"
    end

    ENV['PRY'] = 'true' if args.pry

    begin
      sh %(puppet apply --basemodulepath="#{Dir.pwd}/.." tests/init.pp)
    rescue RuntimeError => e
      puts e.message
      exit 1
    end
  end
end

task :run, [:pry] => :Run_Walkthrough
