#!/usr/bin/env ruby
require 'csv'
require 'json'
require 'yaml'
require 'date'

class Row
  attr_accessor :date, :location, :user_name, :text
  
  def initialize( args= { :type => SYSTEM } )
    args.each_pair do | key, value |
      self.send("#{key}=", value)
    end
  end
end


@date = DateTime.parse('2012-12-01')

def convert_row(row)
  
  begin
    date = DateTime.parse(row['created_at'])
  rescue
    return nil;
  end  
  
  if date < @date
    Row.new(
      date: row['created_at'],
      location: row['user profile description'],
      text: row['source'],
      user_name: row['user_followers_count']
    )
  else
   Row.new(
     date: row['created_at'],
     location: row['user profile location'],
     text: row['text'],
     user_name: row['user_name']
   )
  end		  

end


file = File.open('monusco.json').read
json = JSON.parse(file)

rows = json.map do |j|
  convert_row(j)
end.compact

#rows.each {|r| puts r }

_rows = []
rows.each do |r|
 _rows << r if r.text =~ /#monuseless/i
end

_rows.group_by(&:location).each do |loc, r|
  puts "==============="
  puts "#{loc}"
  r.each {|_r| puts _r.text}
  puts
  puts
  puts
end

