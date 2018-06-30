API Cake - Build Dynamic API Wrappers
==================================================

[![Gem Version](https://badge.fury.io/rb/apicake.svg)](https://badge.fury.io/rb/apicake)
[![Build Status](https://travis-ci.com/DannyBen/apicake.svg?branch=master)](https://travis-ci.com/DannyBen/apicake)
[![Maintainability](https://api.codeclimate.com/v1/badges/07bd0f8653914ce703a6/maintainability)](https://codeclimate.com/github/DannyBen/apicake/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/07bd0f8653914ce703a6/test_coverage)](https://codeclimate.com/github/DannyBen/apicake/test_coverage)

---

This gem allows you to easily build rich API wrappers with minimal code.

It is HTTParty with a Cake.

---


Install
--------------------------------------------------

```
$ gem install apicake
```

Or with bundler:

```ruby
gem 'apicake'
```


TL;DR
--------------------------------------------------

Turn this hypothetical API URL:

```
http://api.recipies.com/cakes?layers=3 
```

To this:

```ruby
Recipies.cakes layers:3
```

Using this code only:

```ruby
class Recipies < APICake::Base
  base_url 'api.recipies.com'
end
```


Features
--------------------------------------------------

- Uses HTTParty
- Built in caching
- Built in save to file
- Built in response parsing (part of HTTParty)
- Built in convert and save to CSV
- Designed for GET-only APIs (e.g., data services)


Usage
--------------------------------------------------

Create a class and inherit from `APICake::Base`.

This class automatically includes HTTParty, so you can do whatever you do in
HTTParty. In addition, the `APICake::Base` class defines a `method_missing`
method, so any call to an undefined method, will simply be converted to a 
URL.

For example:

```ruby
class Recipies << APICake::Base
  base_url 'api.recipies.com/v1'
end

recipies = Rcipies.new

# This will access http://api.recipies.com/v1/cakes
recipies.cakes

# This will access http://api.recipies.com/v1/cakes/chocolate
recipies.cakes 'chocolate'

# This will access http://api.recipies.com/v1/cakes/chocolate?layers=3
recipies.cakes 'chocolate', layers: 3
```

See the [Examples folder][1] for more examples.


Caching
--------------------------------------------------

APICake uses [Lightly][2] for caching. By default, cached objects are stored
in the `./cache` directory for 3600 seconds.

See the [caching example][3].


Method Reference
--------------------------------------------------

For a detailed explanation of the services and methods you get when inheriting
from `APICake::Base`, see the [class documentation][4].


Real World Examples
--------------------------------------------------

These gems use APICake:

- [Fredric][5] - API wrapper for the FRED database ([go straight to API class][8])
- [Intrinio][6] - API wrapper for the Intrinio data service ([go straight to API class][9])
- [Quata][7] - API wrapper for the Quandl data service ([go straight to API class][10])


---

[1]: https://github.com/DannyBen/apicake/tree/master/examples
[2]: https://github.com/DannyBen/lightly
[3]: https://github.com/DannyBen/apicake/blob/master/examples/04-caching.rb
[4]: http://www.rubydoc.info/gems/apicake/0.1.1/APICake/Base
[5]: https://github.com/DannyBen/fredric
[6]: https://github.com/DannyBen/intrinio
[7]: https://github.com/DannyBen/quata
[8]: https://github.com/DannyBen/fredric/blob/master/lib/fredric/api.rb
[9]: https://github.com/DannyBen/intrinio/blob/master/lib/intrinio/api.rb
[10]: https://github.com/DannyBen/quata/blob/master/lib/quata/api.rb