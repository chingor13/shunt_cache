require 'net/http'

module ShuntCache
  module Checker

    class << self
      def wait_for_http(url, options = {})
        retries = options.fetch(:retry, 10)
        wait_time = options.fetch(:wait_time, 6)

        uri = URI(url)

        retries.times do
          begin
            response = request(uri, options)
            code = response.code.to_i
            return true if 200 <= code && 399 >= code
          rescue Errno::ECONNREFUSED, Timeout::Error => e
            sleep(wait_time)
            next
          end
        end

        false
      end

      def request(uri, options = {})
        timeout = options.fetch(:timeout, 10)

        response = nil
        Net::HTTP.start(uri.host, uri.port) do |http|
          http.read_timeout = timeout
          request = Net::HTTP::Get.new(uri.path)
          response = http.request(request)
        end
        response
      end

    end
  end
end