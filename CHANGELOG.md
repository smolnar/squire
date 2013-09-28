### 1.2.4
* Fix gemspec licence (#1)
* Use BasicObject as clean slate for Squire::Setting
* Drop pretty strict ActiveSupport dependency to 3.0.0 or higher.

  *Samuel Molnár*

### 1.2.3
* Fix issue with existing methods. Consider using BasicObject as blank slate 
  for Squire::Settings.

  *Samuel Molnár*

### 1.2.2
* Fix issue with existing methods in Settings.
* Add better accessor caching.

  *Samuel Molnár*

### 1.2.1

* Fix minor bug with ActiveSupport Hash#deep_merge! omitting block for false keys. 
  More: https://github.com/rails/rails/pull/12072 (Waiting for merge and release in new ActiveSupport version).
  Fix is temporararly included in squire/core_ext/hash/deep_merge.rb

  *Samuel Molnár*

### 1.2.0

* Full support for YAML, Hash
* DSL for Base class, config key delegation via method missing.
* Support for Settingslogic-like API via Squire::Base.

  *Samuel Molnár*
