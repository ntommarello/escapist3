require 'jammit'

namespace :utils do
  task :package => :environment do
    Jammit.package!
  end
end