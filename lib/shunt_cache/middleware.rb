module ShuntCache
  class Middleware
    attr_accessor :endpoint_matcher

    def initialize(app, options = {})
      @app = app
      @endpoint_matcher = options.fetch(:endpoint) do
        "/options/full_stack_status"
      end
    end

    def call(env)
      path = env.fetch('REQUEST_PATH') do
        env.fetch('PATH_INFO') do
          env.fetch('REQUEST_URI', '')
        end
      end
      if path.match(endpoint_matcher) && ShuntCache::Status.shunted?
        return ['503', {'Content-Type' => 'text/html'}, ['Maintenance']]
      end
      @app.call(env)
    end

  end
end