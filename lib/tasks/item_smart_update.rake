# We change the interval time for each item based on the growing speed
# of each numbers. If the difference between the newest number and the
# stored number is little (less than 110%), we double the interval
# time. The shortest interval is 180 second and this value is set when
# a new item is created.

namespace :item_smart_update do
  desc "Update the items properties, hatena and retweet periodically"
  task :update => :environment do
    que = check_and_enque
    deque_and_update(que)
  end
end

def check_and_enque
  que = []
  items = Item.all
  items.each do |i|
    if i.updated_at + i.interval < Time.now then
      que << i
    end
  end
  puts "enque"
  que
end

def deque_and_update(que)
  puts "starts deque"
  que.each do |item|
    puts "update #{item.title}"
    item.smart_update
    sleep 1
  end
  puts "end deque"
rescue Timeout::Error
end
