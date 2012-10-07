require 'link_extractor'
require 'spec_helper'

describe LinkExtractor do
  #use_vcr_cassette "link_extractor", record: :new_episodes
  #VCR.use_cassette("test") do
  #end 

  context "a url string is used to find the next page" do
    before do
      @page_url = "http://tynan.com/index.html"
      @max_entries = 20
      @post_matcher = "h1 a.title.fastload"
      @next_page_matcher = "page/"
      @starting_page = 1
      @starting_page_incrementor = 1 
      @site = LinkExtractor.new(@page_url, @max_entries, @post_matcher, 
                                @next_page_matcher, @starting_page,
                                @starting_page_incrementor)
    end
   
    subject { @site }
    it { should respond_to :link_list }
    it { should respond_to :get_posts }
    it { should respond_to :process_page }
    it { should respond_to :post_limit_not_hit? }
    it { should respond_to :get_next_page_url }

    it "has an empty array initialized at the start" do
      @site.link_list.should == []
    end

    it "will search via query string when page incrementor isn't set" do
      @site.search_via_css?.should be_false
    end

  end

  context "the css is used to find the url for the next page" do


  end



end
