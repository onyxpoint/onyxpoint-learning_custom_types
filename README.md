# Learning Custom Types

This module attempts to clearly delineate the execution of a custom type and
provider and demonstrate what you can do with each.

It is meant as a learning and teaching aid and should **not** be used in production
but may be a good place to start when developing a new custom type.

## Usage

This module can be installed on a running master to get an idea of what part
execute on the master and the client. Or you can run it using *puppet apply*
with the following method.

```bash
# Make sure you're using Puppet 3 or higher!

git clone https://github.com/onyxpoint/onyxpoint-learning_custom_types.git
mv onyxpoint-learning_custom_types learning_custom_types
cd learning_custom_types

# Optional
# bundle

rake Run_Walkthrough
```

## Pry

You can also step through the code using [Pry](https://github.com/pry/pry),

```bash
rake Run_Walkthrough[yes]
```

## Support

Please log tickets and issues in the
[Learning Custom Types](https://github.com/onyxpoint/puppet_modules/learning_custom_types)
project on GitHub.

## Copyright

All code Copyright (C) 2015 Onyx Point, Inc.
