# ShuntCache

Store temporary shunt status in a cache to conditionally show maintenance page.

## Motivation

Many load balancer programs (HAProxy, et al), can utilize an HTTP status check to determine if a server is up or down. [dplummer](https://github.com/dplummer) suggested that we could pull machines out of rotation by having their health check endpoint return with the maintenance status response.

Rather than having your app know where all the load balancers are and explicitly telling them to take each server on/offline, we can rely on them to do the right thing when we report that we should be out of rotation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shunt_cache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shunt_cache

## Usage

If you're using rails, the railtie will automatically be loaded. The railtie will install the middleware and rake tasks.

### Rake tasks

* `shunt_cache:shunt` - takes the current machine out of rotation
* `shunt_cache:unshunt` - return the machine to rotation
* `shunt_cache:status` - prints the status of the current machine to STDOUT
* `shunt_cache:wait_for_http` - checks the url at ENV['URL'] to see if it is up

### Capistrano Deploys

Assuming capistrano version 3 (nice sequencing):

```

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do |host|
      execute :rake, 'shunt_cache:shunt'
      sleep(10)
      sudo 'service myservice restart'
      execute :rake, 'shunt_cache:wait_for_http', "URL=http://#{host}:4004/"
      execute :rake, 'shunt_cache:unshunt'
    end
  end

end

```

* First, we shunt the machine, then wait some amount of time. We assume that HAProxy or whatever load balancer we're using has removed it from rotation.
* We can safely restart the service. 
* We then check to make sure that our service is back up. Note this is not our health check because it should report that we're shunted.
* Unshunt the machine because we know the service is running.

## Configuration

```

ShuntCache::Status.configure do |config|
  config.cache = MyCacheStore.new
  config.key = "some key that identifies this machine/service"
  config.logger = SomeLogger.new # optional
end

```

If using rails, the configuration is set by default to use `Rails.cache` as the cache store, generates a key based off hostname and the `Rails.application` name, and sets the logger to the `Rails.logger`

## Contributing

1. Fork it ( https://github.com/chingor13/shunt_cache/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
