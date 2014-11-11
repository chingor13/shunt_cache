module ShuntCache
  class Railtie < ::Rails::Railtie

    initializer 'shunt_cache.set_cache_store' do |app|
      require 'socket'
      ShuntCache::Status.configure do |status|
        status.cache = Rails.cache
        status.key = [
          Rails.application.class.name.deconstantize,
          "shunt_cache",
          Socket.gethostname
        ].join(":")
        status.logger = Rails.logger
      end
    end

    initializer 'shunt_cache.middleware' do |app|
      app.middleware.use ShuntCache::Middleware
    end

    rake_tasks do
      load 'shunt_cache/shunt_cache.rake'
    end

  end
end