require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'ruby-readability'
require 'securerandom'
require 'mechanize'

load '../lib/link_extractor.rb'

#Other
output_file = "test.html"


def random_filename
  "temp_" + SecureRandom.hex(13) + ".html"
end

def include_author?(doc)
  !doc.author.nil? 
end

def author_info(doc)
  if include_author?(doc)
    doc.author 
  else
    "Unknown" 
  end
end

def include_title?(doc)
  !doc.title.nil?
end

def title_info(doc)
  if include_title?(doc)
    doc.title
  else
    "Unknown"
  end
end

def website_encoding_tag
  "<head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\" /></head>"
end

def write_file(page_url)
  output_file = random_filename 
  File.open(output_file, "w") do |file|
    source_page = open(page_url).read
    file.write website_encoding_tag
    doc = Readability::Document.new(source_page)
    file.write "Page URL: "
    file.write page_url
    file.write "Title: "
    file.write title_info(doc)
    file.write "</br>" 
    file.write "Author: "
    file.write author_info(doc)
    file.write "</br>"
    file.write doc.content
    file.write "<hr>"
  end
end

#open each page and write it to a file
def write_to_file
  site.link_list.each do |link|
    write_file(link)  
  end
end

#options = { page_url: 'http://tynan.com',
  #max_entries: 20,
  #next_page_matcher: "page/",
  #post_matcher: "",
  #starting_page: 1,
  #starting_page_incrementor: 1 }

#squid314 LJ
options = { page_url: 'http://squid314.livejournal.com',
  max_entries: 20,
  next_page_matcher: "?skip=",
  post_matcher: "td.caption a.subj-link",
  starting_page: 0,
  starting_page_incrementor: 10 }

#JEYC
#options = { page_url: 'http://just-eat-your-cupcake.blogspot.com',
  #max_entries: 20,
  #next_page_matcher: "a.blog-pager-older-link",
  #post_matcher: "h3.post-title.entry-title a",
  #starting_page: -1,
  #starting_page_incrementor: -1 }

site = LinkExtractor.new(options)
site.get_posts
