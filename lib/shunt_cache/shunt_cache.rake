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
end