# SimpleWhatWeb

It's a simplified & gemified version of [WhatWeb](https://github.com/urbanadventurer/WhatWeb).

## Motivations

WhatWeb is a great tool, but there are some points could be improved IMHO.

- (A little bit) messy codebase.
- Lack of some testing.
- Not gemified.

So I created this.

## Installation

```ruby
gem 'simple_whatweb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_whatweb

## Usage

### As a CLI

```
Usage:
  whatweb scan URL

Options:
  [--aggressive], [--no-aggressive]
  [--default], [--no-default]

Scan against a given URL
```

**Example**

```bash
whatweb scan http://localhost:8000 | jq .
```

```json
{
  "HTTPServer": [
    {
      "name": "server string",
      "string": "WEBrick/1.4.2 (Ruby/2.5.1/2018-03-29)",
      "certainty": 100
    }
  ],
  "Ruby": [
    {
      "regexp": [
        "Ruby"
      ],
      "search": "headers[server]",
      "certainty": 100
    },
    {
      "regexp": [
        "WEBrick"
      ],
      "search": "headers[server]",
      "certainty": 100
    }
  ],
  "Title": [
    {
      "name": "page title",
      "string": "Index of /",
      "certainty": 100
    }
  ]
}
```

### As a library

```ruby
require "whatweb"
require "pp"

# create a scan target
target = WhatWeb::Target.new("http://localhost:8000")
# loads plugins
plugins = WhatWeb::PluginManager.load_plugins

results = {}
plugins.each do |name, plugin|
  # execute a plugin against the target
  result = plugin.execute(target)
  results[name] = result unless result.empty?
end

pp results
# {"HTTPServer"=>
#   [{:name=>"server string",
#     :string=>"WEBrick/1.4.2 (Ruby/2.5.1/2018-03-29)",
#     :certainty=>100}],
#  "Ruby"=>
#   [{:regexp=>["Ruby"], :search=>"headers[server]", :certainty=>100},
#    {:regexp=>["WEBrick"], :search=>"headers[server]", :certainty=>100}],
#  "Title"=>[{:name=>"page title", :string=>"Index of /", :certainty=>100}]}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
