# == Class: learning_custom_types
#
# A simple class to include the custom type that we have created as a resource
# example.
#
# === Authors
#
# Trevor Vaughan <tvaughan@onyxpoint.com>
#
# === Copyright
#
# Copyright 2015 Onyx Point, Inc.
#
class learning_custom_types {

  example_type { 'example_type_one':
    foo => 'example_one_foo',
    bar => 'example_one_bar',
    baz => 'example_one_baz',
  }

  example_type { 'example_type_two':
    foo => 'example_two_foo',
    bar => 'example_two_bar',
    baz => 'example_two_baz',
  }

}
