require 'factory_girl'
FactoryGirl.define do
  factory :url_search, class: TrogScraper::LinkExtractor do
      page_url       "http://squid314.livejournal.com"
      max_entries    5 
      post_matcher   "td.caption a.subj-link"
      next_page_matcher           "?skip="
      starting_page               0
      starting_page_incrementor   10
    initialize_with { attributes }

  end
  factory :css_search, class: TrogScraper::LinkExtractor do
      page_url       "http://googlereader.blogspot.com/"
      max_entries    10
      post_matcher   "h3.post-title a"
      next_page_matcher           "a.blog-pager-older-link"
      starting_page               -1
      starting_page_incrementor   -1 
    initialize_with { attributes }
  end

  #blog with one page which dynamically loads posts
  factory :css_search_dynamic, class: TrogScraper::LinkExtractor do
      page_url       "http://googleblog.blogspot.com/"
      max_entries    10
      post_matcher   "li.post h2.title a"
      next_page_matcher           "-1"
      starting_page               -1
      starting_page_incrementor   -1 
    initialize_with { attributes }
  end
end
