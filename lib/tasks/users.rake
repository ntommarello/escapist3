namespace :users do
    task :reputation => :environment do
      User.all.each do |u|
        if not u.hidden_reputation.nil?
          if u.hidden_reputation < 100
            u.hidden_reputation = u.hidden_reputation + 3
            if u.hidden_reputation > 100
              u.hidden_reputation = 100
            end
            u.save(:false)
          end
        end
      end
    end
end