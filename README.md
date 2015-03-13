# Acenda API client

![enter image description here](http://acenda.com/images/logo.png)

Acenda website: [http://acenda.com](http://acenda.com)
Homepage: [Git repository](http://github.com/torreycommerce/acenda-ruby-sdk)

Author: TorreyCommerce

----------

## Description

The Acenda API Ruby Client makes it very easy to manage oAuth2 authentication process and REST API query.

> **Note:**
  * This client is in Alpha and doesn't have all the features needed *

--------

## Install
Be sure https://rubygems.org/ is in your gem sources.
For normal client usage, this is sufficient:

    $ gem install acenda-client

--------

## Example

```ruby
require 'acenda-client'

# Initalization of the API client with your credentials
cli = Acenda::API.new(_CLIENT_ID_, _CLIENT_SECRET_, _STORE_URL_)

# Basic case of querying with syntax system and sorting
response = cli.query('GET', '/product', {
	:query => 'brand:{$exists:1}'
	:sort => 'id:1'
})

# Display of the results in JSON
puts response.get_result().to_json # [{}]
puts response.get_code() # 200
puts response.get_status() # OK
puts response.get_url() # Your complete URL and URI
puts response.get_params().to_json # {"query": "brand:{$exists:1}", "sort": "id:1"}
puts response.get_number() # 0
```

--------

## Support
Please report bugs on the issue manager of the project on GitHub.
A forum will soon be open to answer questions.

![enter image description here](http://acenda.com/images/logo.png)
