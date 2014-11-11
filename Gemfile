source 'https://rubygems.org'

# Specify your gem's dependencies in shunt_cache.gemspec
gemspec

as_version = ENV["AS_VERSION"] || "default"

as_version = case as_version
when "default"
  ">= 3.2.0"
else
  "~> #{as_version}"
end

gem 'rack'
gem "activesupport", as_version