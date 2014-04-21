#!/usr/bin/env ruby
require 'csv'
require 'json'
require 'yaml'
require 'date'


@date = DateTime.parse('2012-12-01')

def convert_row(row)
  
  begin
    date = DateTime.parse(row['created_at'])
  rescue
    return nil;
  end  
  
  if date < @date
    text = row['source']
    {
      id: row['lang'].split('/').last,
      date: row['created_at'],
      location: row['user profile description'],
      normalized_location: normalize_location(row['user profile description']),
      text: text,
      user_name: row['user_followers_count'],
      user_screen_name: row['user_name'],
      perspective: normalize_perspective(text),
      tags: normalize_tags(text)
    }
  else
    text = row['text']
   {
      id: row['permanent link'].split('/').last,
      date: row['created_at'],
      location: row['user profile location'],
      normalized_location: normalize_location(row['user profile location']),
      text: text,
      user_name: row['user_name'],
      user_screen_name: row['user_screen_name'],
      perspective: normalize_perspective(text),
      tags: normalize_tags(text)

   }
  end		  

end

#!/usr/bin/env ruby

def normalize_location(location)
  case location
  when /kgl|rwd|kigali|rwanda|butare|huye|gisenye/i
    return 'rwanda'
  when /drc|congo|goma|kinshasa|bukavu|masis|kivu|kasai|zaire|kongo/i
    return 'drc'
  when /uganda|kampala|entebbe/i
    return 'uganda'
  else
    return 'international'
  end
end

def normalize_perspective(text)
  if text =~ /#monuseless/i
    return 'useless'
  else
    return nil
  end
end

def normalize_tags(text)
  tags = text.scan(/(?:\s|^)(?:#(?!(?:\d+|\w+?_|_\w+?)(?:\s|$)))(\w+)(?=\s|$)/i).flatten.map!(&:downcase).join(' ')
end

 
lines = CSV.open('data/original/monusco.csv').readlines
keys = lines.delete lines.first
 
data = lines.map do |values|
  hash = Hash[keys.zip(values)]
  convert_row(hash)
end.compact


File.open("data/monusco.json","w") do |f|
  f.puts JSON.pretty_generate(data)
end

# _rows = []
# rows.each do |r|
#  _rows << r if r.text =~ /#monuseless/i
# end

# _rows.group_by(&:location).each do |loc, r|
#   puts "==============="
#   puts "#{loc}"
#   r.each {|_r| puts _r.text}
#   puts
#   puts
#   puts
# end

