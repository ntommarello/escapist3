namespace :challenges do
    task :reset_counter => :environment do
      Challenge.reset_column_information
      Challenge.all.each do |u|
          Challenge.update_counters u.id, :subscribed_challenges_count => u.subscribed_challenges.count
      end
    end
    
    task :mark_vetted => :environment do
      Challenge.reset_column_information
      Challenge.all.each do |u|
        u.vetted = true
        u.save
      end
    end
    
    
    task :regen_thumb => :environment do
      #first_batch = Challenge.find(:all) { |f| f.id > 0 && f.id < 100 }
        errors = []
        
        #16,23,24,35,41,56,70,79,81,148,195,213 no work
        #can't convert nil into String
        #The specified key does not exist.
        
        @challenges = Challenge.find(:all, :conditions=>"id > 213")
       @challenges.each do |u|
         puts u.id
         #if u.photo.exists?
           result = u.photo.reprocess!
          #end
          errors << [u.id, u.errors] unless u.errors.blank?
      
          result
        end
        
        errors.each{|e| puts "error" }
        
    end
    
    
    
end