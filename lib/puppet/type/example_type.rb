require 'pry' if ENV['PRY']

# A custom type to demonstrate how custom types function.
module Puppet
  Puppet::Type.newtype(:example_type) do
    @doc = <<-EOM
      A type demonstrating execution order on the Puppet server.
    EOM

    # This describes a feature that you're going to implement in your provider
    #
    # This is *not* mandatory, but you must have it if you want to disable
    # parameters or properties based on provider features
    #
    # See the documentation for additional details
    feature :walkthrough, 'The ability to do a Walkthrough'
    feature :move_along_nothing_to_see_here, 'Just a stub'

    def initialize(args)
      # Do this *first* since you want the type to set up properly
      # before you start messing about with it.
      super(args)

      # Now, you can do a lot of things here but, be warned, the
      # catalog is not completely compiled yet. However, you *can* get
      # to the class parameters.
      Puppet.warning("#{self[:name]}: Type Initializing")
      binding.pry if defined?(Pry)

      # You can also dig through the currently compiled catalog.
      num_example_types = @catalog.resources.select do |r|
        r.is_a?(Puppet::Type.type(:example_type))
      end.count

      Puppet.warning("#{self[:name]}: Number of Example_types in the catalog: '#{num_example_types + 1}'")
      binding.pry if defined?(Pry)

      # Notice, here, we have to use 'self[:name]' while, in the
      # parameters and properties, we have to use 'resource[:name]' due to the
      # different object scope.
    end

    def finish
      # Stuff to do at the end of your type run.
      Puppet.warning("#{self[:name]}: Type Finishing")
      binding.pry if defined?(Pry)

      # Don't forget to call this *at the end*
      super
    end

    # Do some sanity checking before *executing* on the system
    def pre_run_check
      Puppet.warning("#{self[:name]}: Doing some pre-run checks")
      binding.pry if defined?(Pry)
    end

    newparam(:name) do
      desc 'An arbitrary, but unique, name for the resource.'

      isnamevar

      munge do |value|
        Puppet.warning("#{value}: Param :name -> Munging '#{value}'")
        binding.pry if defined?(Pry)
        value
      end

      validate do |value|
        Puppet.warning("#{value}: Param :name -> Validating '#{value}'")
        binding.pry if defined?(Pry)
      end
    end

    newparam(:foo) do
      desc <<-EOM
        Hey, foo!
      EOM

      # Y U Do Nothing?!!!?
      # Though supported, isrequired just doesn't do anything.
      # See https://projects.puppetlabs.com/issues/4049 for more
      # information
      isrequired

      # Can't get to resource[:name] here!
      Puppet.warning("#{@name}: Param :foo -> Starting")

      validate do |value|
        Puppet.warning("#{@resource[:name]}: Param :foo -> Validating '#{value}'")
        binding.pry if defined?(Pry)
      end

      munge do |value|
        Puppet.warning("#{resource[:name]}: Param :foo -> Munging '#{value}'")
        # Order matters!!
        Puppet.warning("#{resource[:name]}: Param :foo -> :bar is '#{resource[:bar]}'")
        binding.pry if defined?(Pry)

        value
      end
    end

    newproperty(:baz) do
      desc <<-EOM
        Have to have a property to do some work.
      EOM

      # Can't get to resource[:name] here!
      Puppet.warning("#{@name}: Property :baz -> Starting")
      binding.pry if defined?(Pry)

      validate do |value|
        Puppet.warning("#{@resource[:name]}: Property :baz -> Validating '#{value}'")
        Puppet.warning("#{resource[:name]}: Property :baz -> :foo is '#{resource[:foo]}'")
        Puppet.warning("#{resource[:name]}: Property :baz -> :bar is '#{resource[:bar]}'")
        binding.pry if defined?(Pry)
      end

      def insync?(is)
        # The regular insync? method does more than this, but this is a basic
        # equivalency test.
        #
        # You will probably want something much more involved if you call this
        # at all.
        #

        # rubocop:disable Lint/Void
        is == @should

        # Translation:
        #
        # is => The system value
        # @should => What you passed in/munged for the property
        #

        # Note, you have to use @resource, not resource here since
        # you're not in the property any more, you're in the :baz property
        # object.
        Puppet.warning("#{@resource[:name]}: Property :baz -> insync?")
        Puppet.warning("#{@resource[:name]}: My provider has feature :walkthrough!") if provider.feature?(:walkthrough)
        Puppet.warning("#{@resource[:name]}: My provider has feature :something_random!") if provider.feature?(:something_random)
        binding.pry if defined?(Pry)

        # We're returning false just to see the rest of the components
        # fire off.
        false
      end
    end

    # Please keep your Parameters and Properties grouped together. This is just
    # to show you the ordering in the Property above.
    #
    # This parameter requires the :walkthrough feature
    newparam(:bar, :required_features => %w(walkthrough)) do
      desc <<-EOM
        And, bar!
      EOM

      isrequired

      # Can't get to resource[:name] here!
      Puppet.warning("#{@name}: Param :bar -> Starting")
      binding.pry if defined?(Pry)

      validate do |value|
        Puppet.warning("#{@resource[:name]}: Param :bar -> Validating '#{value}'")
        binding.pry if defined?(Pry)
      end

      munge do |value|
        Puppet.warning("#{resource[:name]}: Param :bar -> Munging '#{value}'")
        # Order matters!!
        Puppet.warning("#{resource[:name]}: Param :bar -> :foo is '#{resource[:foo]}'")
        binding.pry if defined?(Pry)

        value
      end
    end

    # I'm not sure why the :required_features set here isn't causing this to
    # fail if you use the 'bad' parameter
    newparam(:bad, :required_features => %w(move_along_nothing_to_see_here)) do
      desc <<-EOM
        A parameter that just can't be used due to missing features in the provider.
        Try using it to see what happens!
      EOM
      defaultto :bad_stuff

      binding.pry if defined?(Pry)
    end

    # Ok, since 'isrequired' doesn't do anything (but it does set a
    # value) we get to do it this way!
    validate do
      required_params = [:foo, :bar, :baz]
      Puppet.warning("#{self[:name]}: Validating")
      binding.pry if defined?(Pry)

      required_params.each do |param|
        unless self[param]
          # Note how we show the user *where* the error is.
          fail Puppet::ParseError, "Hey, I need :#{param} in #{ref} at line #{file}:#{line}"
        end
      end
    end

    autorequire(:file) do
      Puppet.warning("#{self[:name]}: Autorequring file '/tmp/foo'")
      binding.pry if defined?(Pry)

      ['/tmp/foo']
    end

    if Gem::Version.new(Puppet.version) >= Gem::Version.new('4.0.0-alpha')
      autobefore(:service) do
        Puppet.warning("#{self[:name]}: Autobeforing service 'foo_service'")
        binding.pry if defined?(Pry)

        ['foo_service']
      end
      autosubscribe(:file) do
        Puppet.warning("#{self[:name]}: Autosubscribing file '/tmp/bar'")
        binding.pry if defined?(Pry)

        ['/tmp/bar']
      end
      autonotify(:exec) do
        Puppet.warning("#{self[:name]}: Autonotifying exec 'run_me'")
        binding.pry if defined?(Pry)

        ['run_me']
      end
    end
  end
end
