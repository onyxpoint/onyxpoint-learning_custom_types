#learning_custom_types

This module attempts to clearly delineate the execution of a custom type and
provider and demonstrate what you can do with each.

It is meant as a learning and teaching aid and should not be used in production
but may be a good place to start when developing a new custom type.

##Usage

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

cd learning_custom_types
puppet apply --basemodulepath=$PWD/../ tests/init.pp
```

##Pry

If you want to step through the code using [Pry](https://github.com/pry/pry),
set a **PRY** environment variable.

```bash
export PRY=true
```

To stop using Pry, simply unset the variable.

```bash
unset PRY
```

##Support

Please log tickets and issues in the
[Learning Custom Types](https://github.com/onyxpoint/puppet_modules/learning_custom_types)
project on GitHub.

