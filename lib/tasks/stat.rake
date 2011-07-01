# Collect stats every day

namespace :stat do
  desc "Update the stats"
  task :update => :environment do
    date = Time.now.strftime('%Y-%m-%d')
    user_num = User.all.size
    item_num = Item.all.size
    puts "#{date}: users %4d" % user_num
    puts "#{date}: items %4d" % item_num
  end
end
