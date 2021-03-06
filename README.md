# Squire

[![Build Status](https://travis-ci.org/smolnar/squire.svg?branch=master)](https://travis-ci.org/smolnar/squire)

Squire handles your configuration per class/file by common config DSL and extensible source formats.

It's designed to support multiple formats (for now, Hash and YAML) and replace [Settingslogic](https://github.com/binarylogic/settingslogic) that lacks some crutial features like default/base namespace or extensibility for another source formats.


## Installation

Add this line to your application's Gemfile:

    gem 'squire'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install squire

## Usage

### Setting up existing module or class

If you want to provide configuration for existing object or class, just include `Squire` like this

```ruby
class Elephant
  include Squire

  squire.source    'source.yml' # or Hash
  squire.namespace 'namespace'

  # or 

  squire do
    namespace 'namespace'
    ....
  end
end
```

After that, you can access `Elephanth.config`. For example:

```ruby
Elephant.config.a # => value from in source.yml

Elephant.config.a? # => true

# You can change loaded settings as you like during runtime
Elephant.config do |config|
  config.a = 1

  config.nested do |nested|
    ....
  end
end
```

No other methods except `squire` and `config` are included.

### Settingslogic equivalence

For replacing Settingslogic functionality, you can refactor your configuration like this:

```yaml
-- source.yml

common: &common
  a: 1
  b: 2

  nested:
    c: 3
    d: 5

namespace:
  <<: *common

  nested:
    d: 4
```

```ruby
class Configuration
  include Squire::Base

  squire.source    'source.yml'
  squire.namespace 'namespace', base: :common
end

Configuration.nested.d # => 4, namepace values overrides defaults
Configuration.nested.c # => 3

# or

Configuration.config.nested.d # => 4
Configuration.config.nested.c # => 3
```

After including `Squire::Base`, you can access `squire` and `config`, but you dont have to write `Configuration.config.a` to access settings, just type `Configuration.a` and the call gets delegated to `config`.

Default namespace set by `base` option in `squire.namespace` is used for merging default values for all namespaces, since they get overriden by YAML and other parsers. For more information, see [Settingslogic issue](https://github.com/binarylogic/settingslogic/issues/21).

## Statistics

Run `bundle exec ruby benchmark/settings_access.rb`. 
Example uses Hash with 10 000 keys.

Single access:
```
Rehearsal -------------------------------------------------
Squire          0.740000   0.020000   0.760000 (  0.761124)
Settingslogic   8.030000   0.040000   8.070000 (  8.106668)
---------------------------------------- total: 8.830000sec

                    user     system      total        real
Squire          0.050000   0.000000   0.050000 (  0.048144)
Settingslogic   0.040000   0.000000   0.040000 (  0.045643)
```

First access of key in `Settingslogic` is painfully slow, as you can see. But after defining accessor, the second access
is just a matter of miliseconds.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licence 

### This code is free to use under the terms of the MIT license.

Copyright (c) 2013 Samuel Molnár

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
