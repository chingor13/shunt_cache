Bundler.require(:default, :test)

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'minitest/autorun'
require 'webmock/minitest'  

require 'active_support/cache'
require 'pp'