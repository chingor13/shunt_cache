require 'test_helper'

class StatusTest < Minitest::Test

  def setup
    super
    cache = ActiveSupport::Cache::MemoryStore.new
    ShuntCache::Status.configure do |status|
      status.cache = cache
      status.key = "test_key"
    end
  end

  def teardown
    ShuntCache::Status.configure do |status|
      status.cache = nil
      status.key = nil
    end

    super
  end

  def test_defaults_to_normal
    assert_equal false, ShuntCache::Status.shunted?
    assert_equal ShuntCache::Status::UNSHUNTED, ShuntCache::Status.status
  end

  def test_can_shunt_and_unshunt
    assert_equal false, ShuntCache::Status.shunted?

    # shunt!
    assert ShuntCache::Status.shunt!

    # ensure that we've set the right state
    assert_equal true, ShuntCache::Status.shunted?
    assert_equal ShuntCache::Status::SHUNTED, ShuntCache::Status.status

    # unshunt!
    assert ShuntCache::Status.unshunt!

    # ensure that we've set the right state
    assert_equal false, ShuntCache::Status.shunted?
    assert_equal ShuntCache::Status::UNSHUNTED, ShuntCache::Status.status
  end
end