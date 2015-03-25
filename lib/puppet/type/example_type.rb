module Puppet
  Puppet::Type.newtype(:example_type) do
    @doc = <<-EOM
      A type demonstrating execution order on the Puppet server.
    EOM

    def initialize(args)
      # Do this *first* since you want the type to set up properly
      # before you start messing about with it.
      super(args)

      # Now, you can do a lot of things here but, be warned, the
      # catalog is not completely compiled yet. However, you *can* get
      # to the class parameters.
      Puppet.warning("#{self[:name]}: Type Initializing")

      # You can also dig through the currently compiled catalog.
      num_example_types = @catalog.resources.find_all { |r|
        r.is_a?(Puppet::Type.type(:example_type))
      }.count

      Puppet.warning("#{self[:name]}: Number of Example_types in the catalog: '#{num_example_types+1}'")

      # Notice, here, we have to use 'self[:name]' while, in the
      # parameters and properties, we have to use 'resource[:name]' due to the
      # different object scope.
    end

    def finish
      # Stuff to do at the end of your type run.
      Puppet.warning("#{self[:name]}: Type Finishing")
      
      # Don't forget to call this *at the end*
      super
    end

    newparam(:name) do
      desc "An arbitrary, but unique, name for the resource."

      isnamevar

      munge do |value|
        Puppet.warning("#{resource[:name]}: Param :name -> Munging '#{value}'")
        value
      end

      validate do |value|
        Puppet.warning("#{resource[:name]}: Param :name -> Validating '#{value}'")
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
      Puppet.warning("Param :foo -> Starting")

      validate do |value|
        Puppet.warning("#{resource[:name]}: Param :foo -> Validating '#{value}'")
      end

      munge do |value|
        Puppet.warning("#{resource[:name]}: Param :foo -> Munging '#{value}'")
        # Order matters!!
        Puppet.warning("#{resource[:name]}: Param :foo -> :bar is '#{resource[:bar]}'")

        value
      end
    end

    newproperty(:baz) do
      desc <<-EOM
        Have to have a property to do some work.
      EOM

      # Can't get to resource[:name] here!
      Puppet.warning("Property :baz -> Starting")

      validate do |value|
        Puppet.warning("#{resource[:name]}: Property :baz -> Validating '#{value}'")
        Puppet.warning("#{resource[:name]}: Property :baz -> :foo is '#{resource[:foo]}'")
        Puppet.warning("#{resource[:name]}: Property :baz -> :bar is '#{resource[:bar]}'")
      end

      def insync?(is)
        # The regular insync? method does more than this, but this is a basic
        # equivalency test.
        #
        # You will probably want something much more involved if you call this
        # at all.
        
        is == @should
        
        # Note, you have to use @resource, not resource here since
        # you're not in the property any more, you're in the :baz property
        # object.
        Puppet.warning("#{@resource[:name]}: Property :baz -> insync?")
        # We're returning false just to see the rest of the components
        # fire off.
        false
      end
    end

    # Please keep your Parameters and Properties grouped together. This is just
    # to show you the ordering in the Property above.
    newparam(:bar) do
      desc <<-EOM
        And, bar!
      EOM

      isrequired

      # Can't get to resource[:name] here!
      Puppet.warning("Param :bar -> Starting")

      validate do |value|
        Puppet.warning("#{resource[:name]}: Param :bar -> Validating '#{value}'")
      end

      munge do |value|
        Puppet.warning("#{resource[:name]}: Param :bar -> Munging '#{value}'")
        # Order matters!!
        Puppet.warning("#{resource[:name]}: Param :bar -> :foo is '#{resource[:foo]}'")

        value
      end
    end

    # Ok, since 'isrequired' doesn't do anything (but it does set a
    # value) we get to do it this way!
    validate do
      required_params = [:foo, :bar, :baz]
      Puppet.warning("#{self[:name]}: Validating")
      required_params.each do |param|
        if not self[param] then
          # Note how we show the user *where* the error is.
          raise Puppet::ParseError,"Hey, I need :#{param} in #{self.ref} at line #{self.file}:#{self.line}"
        end
      end
    end

    autorequire(:file) do
      Puppet.warning("#{self[:name]}: Autorequring file '/tmp/foo'")
      ["/tmp/foo"]
    end

    if Gem::Version.new(Puppet.version) >= Gem::Version.new('4.0.0-alpha')
      autobefore(:service) do
        Puppet.warning("#{self[:name]}: Autobeforing service 'foo_service'")
        ["foo_service"]
      end
      autosubscribe(:file) do
        Puppet.warning("#{self[:name]}: Autosubscribing file '/tmp/bar'")
        ["/tmp/bar"]
      end
      autonotify(:exec) do
        Puppet.warning("#{self[:name]}: Autonotifying exec 'run_me'")
        ["run_me"]
      end
    end
  end
end
