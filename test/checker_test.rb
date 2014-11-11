require 'test_helper'

class CheckerTest < Minitest::Test
  TEST_URL = 'http://localhost:3000/options/full_stack_status'

  def test_maintenance
    stub_request(:get, TEST_URL)
      .to_return(body: 'Maintenance', status: 503)

    res = ShuntCache::Checker.wait_for_http(TEST_URL, {
      wait_time: 0
    })
    assert_equal false, res
  end

  def test_connection_issues
    stub_request(:get, TEST_URL)
      .to_raise(Errno::ECONNREFUSED)

    res = ShuntCache::Checker.wait_for_http(TEST_URL, {
      wait_time: 0
    })
    assert_equal false, res
  end

  def test_should_retry
    stub_request(:get, TEST_URL)
      .to_raise(Errno::ECONNREFUSED).then
      .to_return(body: 'OK')

    res = ShuntCache::Checker.wait_for_http(TEST_URL, {
      wait_time: 0
    })
    assert_equal true, res
  end

  def test_success
    stub_request(:get, TEST_URL)
      .to_return(body: 'OK')

    res = ShuntCache::Checker.wait_for_http(TEST_URL)
    assert_equal true, res
  end

end