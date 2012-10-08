require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'securerandom'
require 'mechanize'

load '../lib/link_extractor.rb'
load '../lib/content_extractor.rb'

def random_filename
  "temp_" + SecureRandom.hex(13) + ".html"
end

def write_html_headers(filename)
  File.open(filename, "w") do |file|
    file.write "<html>
                <head><title> Kindle Document </title>
                <meta http-equiv=\"Content-Type\" 
                 content=\"text/html;charset=utf-8\" />
                </head>
                <body>"
  end
end

def write_html_ending(filename)
  File.open(filename, "a") do |file|
    file.write "</body></html>"
  end
end

def write_file(page_url, output_file)
  File.open(output_file, "a") do |file|
    source_page = open(page_url).read
    doc = ContentExtractor.new(source_page)
    file.write "Page URL: "
    file.write page_url
    file.write "</br>" 
    file.write "Title: "
    file.write doc.title_info
    file.write "</br>" 
    file.write "Author: "
    file.write doc.author_info
    file.write "</br>"
    file.write doc.content
    file.write "<hr>"
  end
end

def create_html_file(link_list)
  output_file = random_filename
  write_html_headers(output_file)

  link_list.each do |link|
    puts "Processing #{link}"
    write_file(link, output_file)
  end

  write_html_ending(output_file)
end

#options = { page_url: 'http://tynan.com',
#max_entries: 20,
#next_page_matcher: "page/",
#post_matcher: "",
#starting_page: 1,
#starting_page_incrementor: 1 }

#squid314 LJ
#options = { page_url: 'http://squid314.livejournal.com',
  #max_entries: 20,
  #next_page_matcher: "?skip=",
  #post_matcher: "td.caption a.subj-link",
  #starting_page: 0,
  #starting_page_incrementor: 10 }

#JEYC
options = { page_url: 'http://just-eat-your-cupcake.blogspot.com',
max_entries: 20,
next_page_matcher: "a.blog-pager-older-link",
post_matcher: "h3.post-title.entry-title a",
starting_page: -1,
starting_page_incrementor: -1 }

site = LinkExtractor.new(options)
site.get_posts
puts "Calling html loader"
create_html_file(site.link_list)
