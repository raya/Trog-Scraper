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

def write_file(page_url, output_file, index)
  File.open(output_file, "a") do |file|
    source_page = open(page_url).read
    doc = ContentExtractor.new(source_page)
    file.write "<mbp:pagebreak />"
    file.write "<h3><a name=\"post-#{index+1}\">#{doc.title_info}</a></h3>"
    file.write "<h5>Page URL: "
    file.write page_url + "</h5>"
    file.write "<h5>Author: "
    file.write doc.author_info + "</h5>"
    file.write doc.content

  end
end

def create_html_file(link_list)
  output_file = random_filename
  write_html_headers(output_file)
  create_toc(output_file, link_list.length)
  link_list.each_with_index do |link, index|
    puts "Processing #{link}"
    write_file(link, output_file, index)
  end

  write_html_ending(output_file)
end

def create_toc(filename, index)
  File.open(filename, "a") do |file|
    file.write "<h3>Table of Contents</h3>"
    file.write "<br>"
    1.upto(index) do |i|
      file.write "<a href=\"#post-#{i}\">Post #{i}</a>"
      file.write "<br><br>"
    end
  end
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
  max_entries: 5,
  next_page_matcher: "a.blog-pager-older-link",
  post_matcher: "h3.post-title.entry-title a",
  starting_page: -1,
  starting_page_incrementor: -1 }

site = LinkExtractor.new(options)
site.get_posts
puts "Calling html loader"
create_html_file(site.link_list)
