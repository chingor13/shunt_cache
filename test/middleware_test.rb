require 'test_helper'

class MiddlewareTest < Minitest::Test

  def setup
    super
    @app = ShuntCache::Middleware.new(proc{[200,{},['Hello, world.']]})
    @request = Rack::MockRequest.new(@app)

    # should default to unshunted
    cache = ActiveSupport::Cache::MemoryStore.new
    ShuntCache::Status.configure do |status|
      status.cache = cache
      status.key = "test_key"
    end
    assert_equal false, ShuntCache::Status.shunted?
  end

  def teardown
    ShuntCache::Status.clear!
    super
  end

  def test_unshunted_hitting_test_endpoint
    response = @request.get('/options/full_stack_status')

    assert_unshunted(response)
  end

  def test_shunted_hitting_test_endpoint
    ShuntCache::Status.shunt!

    response = @request.get('/options/full_stack_status')

    assert_shunted(response)
  end

  def test_unshunted_hitting_non_status_endpoint
    response = @request.get('/')

    assert_unshunted(response)
  end

  def test_shunted_hitting_non_status_endpoint
    ShuntCache::Status.shunt!

    response = @request.get('/')

    assert_unshunted(response)
  end

  def test_custom_endpoint
    ShuntCache::Status.shunt!

    @app.endpoint_matcher = '/foo/bar'
    response = @request.get('/foo/bar')

    assert_shunted(response)
  end

  def test_custom_endpoint_regex
    ShuntCache::Status.shunt!

    @app.endpoint_matcher = /\/foo\/.*/
    response = @request.get('/foo/bar')

    assert_shunted(response)

    response = @request.get('/foo/qwerty')
    assert_shunted(response)
  end

  private

  def assert_unshunted(response)
    assert_equal 200, response.status
    assert_equal 'Hello, world.', response.body
  end

  def assert_shunted(response)
    assert_equal 503, response.status
    assert_equal 'Maintenance', response.body
  end

end