namespace :shunt_cache do
  desc 'Mark the site as shunted'
  task :shunt => :environment do
    ShuntCache::Status.shunt!
  end

  desc 'Mark the site as unshunted'
  task :unshunt => :environment do
    ShuntCache::Status.unshunt!
  end

  desc 'Check the site status'
  task :status => :environment do
    puts ShuntCache::Status.status
  end

  desc "Wait until we get a 200 or 300 ranged http response code for ENV['URL']"
  task :wait_for_http => :environment do
    url = ENV.fetch('URL')
    options = {
      :host => ENV['HOST']
    }
    success = ShuntCache::Checker.wait_for_http(url, options)
    unless success
      puts "error checking: #{url} - never returned with status within 200..399"
      exit(1)
    end
  end
end