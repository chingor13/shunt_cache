require 'singleton'
require 'forwardable'

module ShuntCache
  class Status
    include Singleton
    class << self
      extend Forwardable
      def_delegators :instance, :shunt!, :unshunt!, :status, :shunted?
    end
    attr_accessor :key, :cache, :logger

    SHUNT_STATUS_SHUNTED = "shunted"
    SHUNT_STATUS_UNSHUNTED = "ok"

    def self.configure
      yield instance
    end

    def status
      cache.fetch(key) do
        SHUNT_STATUS_UNSHUNTED
      end
    end

    def shunted?
      status == SHUNT_STATUS_SHUNTED
    end

    def shunt!
      log(:info, "Shunting site with key: #{key}")
      cache.write(key, SHUNT_STATUS_SHUNTED)
    end

    def unshunt!
      log(:info, "Unshunting site with key: #{key}")
      cache.write(key, SHUNT_STATUS_UNSHUNTED)
    end

    private

    def log(level, msg)
      logger.send(level, msg) if logger
    end
  end
end