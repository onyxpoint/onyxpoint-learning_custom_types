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
  end

  def baz
    # This is what 'is' ends up being in insync?
    Puppet.warning("#{@resource[:name]}: Provider: Property :baz -> getter")
    'system_baz'
  end

  def baz=(should)
    Puppet.warning("#{@resource[:name]}: Provider: Property :baz -> setter")
  end

  def flush
    Puppet.warning("#{@resource[:name]}: Provider: flush")
  end

  def self.post_resource_eval
    Puppet.warning("Provider: All Resource Application Complete")

    if $example_type_classvars[:initialized]
      Puppet.warning("Provider: Destroying Classvars")
      $example_type_classvars = nil
    end
  end
end
