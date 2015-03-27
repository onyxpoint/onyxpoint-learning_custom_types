Puppet::Type.type(:example_type).provide(:ruby) do

  # Make sure we have the 'rake' command
  # We're not worrying about the path this time
  commands :rake => 'rake'

  # This provider is only suitable if 15 is less than 49
  # Try uncommenting the next line and see what happens!
  confine :true => (15 < 49)
  # confine :true => (15 > 49)

  # This can be any expression
  confine :true => (Facter.value(:memoryfree_mb).to_i > 10)

  # This only works if the Puppet version fact is the running Puppet version
  # (Ok, this isn't a good example, but it's the only thing I have that works everywhere)
  confine :puppetversion => Puppet.version

  # This is the default for Linux
  # If more than one provider is suitable, this one wins
  defaultfor :kernel => :Linux

  # We're declaring that this provider has the 'walkthrough' feature
  # This is yet another way to restrict how your types and providers interact
  has_feature :walkthrough

  Puppet.warning('Setting Property Class Variables')
  # If you didn't read the previous post, these are *global*.
  $example_type_classvars = {
    :example => true,
    :count => 0,
    :initialized => false
  }

  def initialize(*args)
    super(*args)

    Puppet.warning('Provider: Initializing Classvars')
    $example_type_classvars[:initialized] = true unless $example_type_classvars[:initialized]

    Puppet.warning("Provider Initialization :name= '#{@resource[:name]}'")
    Puppet.warning("Provider Initialization :foo = '#{@resource[:foo]}'")
    Puppet.warning("Provider Initialization :bar = '#{@resource[:bar]}'")

    binding.pry if defined?(Pry)
  end

  def baz
    # This is what 'is' ends up being in insync?
    Puppet.warning("#{@resource[:name]}: Provider: Property :baz -> getter")
    binding.pry if defined?(Pry)

    'system_baz'
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def baz=(should)
    Puppet.warning("#{@resource[:name]}: Provider: Property :baz -> setter")
    binding.pry if defined?(Pry)
  end

  def flush
    Puppet.warning("#{@resource[:name]}: Provider: flush")
    binding.pry if defined?(Pry)
  end

  def self.post_resource_eval
    Puppet.warning('Provider: All Resource Application Complete')
    binding.pry if defined?(Pry)

    if $example_type_classvars[:initialized]
      Puppet.warning('Provider: Destroying Classvars')
      binding.pry if defined?(Pry)

      $example_type_classvars = nil
    end
  end
end
