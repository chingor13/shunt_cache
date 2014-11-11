require "shunt_cache/version"

module ShuntCache
  autoload :Checker, 'shunt_cache/checker'
  autoload :Middleware, 'shunt_cache/middleware'
  autoload :Status, 'shunt_cache/status'
end

require 'shunt_cache/railtie' if defined?(Rails)