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
  #output_file = random_filename 
  output_file = "test.html"
  File.open(output_file, "a") do |file|
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

#gets the URLs of main posts from a livejournal website
def get_livejournal_posts(starting_page=0, max_pages=1) 
  regex = "a.subj-link"
  link_list = []
  next_page_script = "?skip="

  starting_page.upto(max_pages) do |count|
    current_page = base_url + "/" + next_page_script + (count * 10).to_s
    page = Nokogiri::HTML(open(current_page))
    page.css(regex).each do |link|
      link_list << link['href']
    end
  end
end

#open each page in an array of links and write them to a file
def write_links_to_file(link_list)
  link_list.each do |link|
    write_file(link)  
  end
end


#Gets the URLs of posts from a SETT site
def get_sett_posts(max_entries=5, page_url)
  matcher = "div.content a.title.fastload"
  link_list = []
  page = Nokogiri::HTML(open(page_url))
  links = page.css(matcher).each do |link|
    link_list << link['href'] 
    write_link
  end
  return link_list
end

#gets posts on an index page based on the post and next_page matchers
def get_posts_from_index(page_url, max_entries=5, post_matcher, next_page_matcher)
  link_list = []
  post_count = 0

  begin
    #open page
  end while link_list.length < max_entries

  page = Nokogiri::HTML(open(page_url))
  page.css(post_matcher).each do |link|
    link_list << link['href']
    post_count += 1
    break if post_count >= max_entries
  end
  puts link_list
end

def get_posts_from_page(page_url, max_entries, post_matcher, link_list)
  page = Nokogiri::HTML(open(page_url))
  page.css(post_matcher).each do |link|
    link_list << link['href']
    post_count += 1
    break if post_count >= max_entries
  end
  return link_list 
end

#Sett Blog
#page_url = "http://sebastianmarshall.com"
#post_matcher = "div.content a.title.fastload"
#next_page_string = "page/"
#site = LinkExtractor.new(page_url, 20, post_matcher, next_page_string,0, 1)
#site.get_posts_via_url
#puts site.link_list

#livejournal squid314
#page_url = "http://squid314.livejournal.com"
#post_matcher = "td.caption a.subj-link"
#next_page_string = "?skip="
#starting_page = 0
#site = LinkExtractor.new(page_url, 20, post_matcher, next_page_string,0,10)
#site.get_posts
#puts site.link_list

#maria blog
page_url = "http://just-eat-your-cupcake.blogspot.com"
post_matcher = "h3.post-title.entry-title a"
next_page_string = "a#Blog1_blog-pager-older-link"
site = LinkExtractor.new(page_url, 20, post_matcher, next_page_string,0,-1)
site.get_posts
puts site.link_list
