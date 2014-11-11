require 'singleton'
require 'forwardable'

module ShuntCache
  class Status
    include Singleton
    class << self
      extend Forwardable
      def_delegators :instance, :shunt!, :unshunt!, :status, :shunted?, :clear!
    end
    attr_accessor :key, :cache, :logger

    SHUNTED = "shunted"
    UNSHUNTED = "ok"

    def self.configure
      yield instance
    end

    def status
      cache.fetch(key) do
        UNSHUNTED
      end
    end

    def shunted?
      status == SHUNTED
    end

    # reset to default
    def clear!
      unshunt!
    end

    def shunt!
      log(:info, "Shunting site with key: #{key}")
      cache.write(key, SHUNTED)
    end

    def unshunt!
      log(:info, "Unshunting site with key: #{key}")
      cache.write(key, UNSHUNTED)
    end

    private

    def log(level, msg)
      logger.send(level, msg) if logger
    end
  end
end