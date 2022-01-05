#!/usr/bin/env ruby

# Catholic Lectures
# Eduardo Manuel Cruz-Betances 2022

require 'net/http'
require 'nokogiri'
require 'date'
require 'calendarium-romanum'
I18n.locale = :es

if ARGV.length > 0
  begin
    date = Date.strptime(ARGV[0], '%d%m%y')
  rescue Date::Error
    puts "\x1b[31mERROR: \x1b[3mLa fecha \x1b[4m#{ARGV[0]}\x1b[24m no es válida\x1b[0m"
    exit 1
  end
  next_arg = 1
else
  date = Date.today
  next_arg = 0
end
calendar = CalendariumRomanum::Calendar.for_day(date)
catholic_day = calendar[date]
usccb_url = "https://bible.usccb.org/es/bible/lecturas/"
day_url = date.strftime("%m%d%y.cfm")

res = Net::HTTP.get(URI(usccb_url + day_url))
doc = Nokogiri.HTML5(res)

lecturas = doc.css(".address").map {|x| x.text.strip }
if lecturas.size < 4 
  puts "\x1b[31mERROR: \x1b[3mno se han podido procesar las lecturas\x1b[0m"
  exit 1
end
i = 0
puts date.strftime "\x1b[3mLecturas para %B %d, %Y\x1b[0m"
case catholic_day.celebrations.first.colour.symbol
when :white
  colour = 37
when :green
  colour = 32
when :violet
  colour = 35
when :red
  colour = 31
end
puts "\x1b[1;32m#{catholic_day.celebrations.first.title}\x1b[0m"
puts "Primera Lectura:\t" + lecturas[i]
puts "Salmo:\t\t\t" +  lecturas[i+1]
if (lecturas.size >= 5)
  puts "Segunda Lectura:\t" + lecturas[i+2]
  i +=1
end
puts "Aleluya:\t\t" + lecturas[i+2]
puts "Evangelio:\t\t\x1b[1;31m" + lecturas[i+3]
