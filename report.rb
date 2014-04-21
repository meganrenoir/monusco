require 'json'

tweet_file = File.open('data/monusco.json').read
tweets    = JSON.parse(tweet_file)


locations    = tweets.group_by { |twts| twts['normalized_location'] }
participants = tweets.group_by { |twts| twts['user_screen_name'] } 



puts "Participants #{participants.size}"


locations.each do |location, twts|

  puts location

  loc_parts = twts.group_by { |twts| twts['user_screen_name'] } 

  puts "participants = #{loc_parts.count}"

end
