require 'nokogiri'
require 'open-uri'

class LinkExtractor 
  attr_reader :link_list

  def initialize(page_url, max_entries=10, post_matcher, next_page_matcher,
                 starting_page, starting_page_incrementor)
    @page_url = page_url
    @max_entries =  max_entries 
    @post_matcher = post_matcher
    @next_page_matcher = next_page_matcher
    @starting_page = starting_page
    @starting_page_incrementor = starting_page_incrementor
    @link_list = []
  end

  #Get list of posts based on a script, ex. blog.com/page/3
  def get_posts_via_url

    while post_limit_not_hit? 
      current_url = @page_url + "/" + @next_page_matcher + @starting_page.to_s
      puts "Opening: " + current_url
      process_page(current_url)
      @starting_page += @starting_page_incrementor 
    end
  end

  #get list of posts on page based on a css attribute
  def get_posts_via_css
    current_page = @page_url 
    while post_limit_not_hit?
      puts "Opening: " + current_page
      process_page(current_page)
      next_page = Nokogiri::HTML(open(current_page))
      current_page = next_page.css(@next_page_matcher)[0]['href']
    end
  end

  #get posts. If starting_page_incrementor is -1, the next page will
  #be determined by css
  def get_posts
    if @starting_page_incrementor == -1
      get_posts_via_css
    else
      get_posts_via_url
    end
  end

  #Put links to main posts in array link_list
  def process_page(current_url)
    current_page = Nokogiri::HTML(open(current_url))
    current_page.css(@post_matcher).each do |link|
      link_list << link['href']
      break if link_list.length >= @max_entries
    end
  end

  def post_limit_not_hit?
    link_list.length < @max_entries
  end
end
