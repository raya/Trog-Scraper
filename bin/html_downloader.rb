require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'ruby-readability'
require 'securerandom'
require 'mechanize'

load '../lib/link_extractor.rb'

#Future
blog_engine = 0 
body_config = ""

#URL Info
base_url = "http://squid314.livejournal.com"
next_page_script = "?skip="


#Config
max_entries = 10
comment_section = false 

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
#crawl website
#agent = Mechanize.new()
#regex = ".subj-link"
#puts agent.get(page_url).search(regex)#:w.map(&:text).map(&:strip)

#get all links which lead to individual posts
def get_link_list
  regex = "a.subj-link"
  link_list = []
  starting_page = 0
  max_pages = 1 

  starting_page.upto(max_pages) do |count|
    current_page = base_url + "/" + next_page_script + (count * 10).to_s
    page = Nokogiri::HTML(open(current_page))
    page.css(regex).each do |link|
      link_list << link['href']
    end
  end
  puts link_list
end
#open each page and write it to a file
def write_to_file
  link_list.each do |link|
    write_file(link)  
  end
end


#SETT Bloc
#page_url = "http://sebastianmarshall.com"
#max_entries = 20
#next_page_matcher = "page/"
#starting_page = 1
#starting_page_incrementor = 1
#post_matcher = ""

page_url = "http://squid314.livejournal.com"
max_entries = 20
next_page_matcher = "?skip="
post_matcher = "td.caption a.subj-link"
starting_page = 0
starting_page_incrementor = 10

#page_url = "http://just-eat-your-cupcake.blogspot.com/"
#max_entries = 20
#next_page_matcher = "a.blog-pager-older-link"
#post_matcher = "h3.post-title.entry-title a"
#starting_page = -1
#starting_page_incrementor = -1

site = LinkExtractor.new(page_url, max_entries, post_matcher, next_page_matcher,
                         starting_page, starting_page_incrementor)
site.get_posts
