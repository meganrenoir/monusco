require 'csv'
require 'json'

csv_string = CSV.generate do |csv|
  JSON.parse(File.open("data/monusco.json").read).each do |hash|
    csv << hash.values
  end
end

File.open('data/monusco.csv', 'w') do |f|
  f.puts csv_string
end

