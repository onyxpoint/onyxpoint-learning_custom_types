Puppet::Type.type(:example_type).provide(:ruby) do

  Puppet.warning("Setting Property Class Variables")
  # If you didn't read the previous post, these are *global*.
  $example_type_classvars = {
   :example => true,
   :count => 0,
   :initialized => false
  }

  def initialize(*args)
    super(*args)

    Puppet.warning("Provider: Initializing Classvars")
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

  def baz=(should)
    Puppet.warning("#{@resource[:name]}: Provider: Property :baz -> setter")
    binding.pry if defined?(Pry)
  end

  def flush
    Puppet.warning("#{@resource[:name]}: Provider: flush")
    binding.pry if defined?(Pry)
  end

  def self.post_resource_eval
    Puppet.warning("Provider: All Resource Application Complete")
    binding.pry if defined?(Pry)

    if $example_type_classvars[:initialized]
      Puppet.warning("Provider: Destroying Classvars")
      binding.pry if defined?(Pry)

      $example_type_classvars = nil
    end
  end
end
