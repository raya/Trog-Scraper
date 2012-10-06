require 'rubygems'
require 'readability'
require 'open-uri'

source = open('http://squid314.livejournal.com/332946.html').read
puts Readability::Document.new(source).content
