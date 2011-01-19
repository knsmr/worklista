# We change the interval time for each item based on the growing speed
# of each numbers. If the difference between the newest number and the
# stored number is little (less than 110%), we double the interval
# time. The shortest interval is 180 second and this value is set when
# a new item is created.

namespace :item do
  desc "Update the items properties, hatena and retweet periodically"
  task :smart_update => :environment do
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
  puts "enqued #{que.map(&:id)}"
  que
end

def deque_and_update(que)
  puts "starts deque"
  que.each do |item|
    puts "update #{item.title}"
    begin
      item.smart_update
    rescue Timeout::Error
      puts "503...?"
      sleep 5
      puts "Retrying."
      retry
    end
    sleep 1
  end
  puts "end deque"
end
