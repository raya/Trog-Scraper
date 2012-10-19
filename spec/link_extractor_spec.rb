require 'link_extractor'
require 'spec_helper'
require 'factory_girl'
require 'support/vcr_setup'

module TrogScraper
  describe LinkExtractor do

    FactoryGirl.find_definitions

    describe "searching via URL" do

      context "all inputs are correct" do
        before(:each) do
          attributes = FactoryGirl.build(:url_search)
          @max_entries = attributes[:max_entries]
          @site = LinkExtractor.new(attributes)

          VCR.use_cassette('valid_url_search') do
            @site.get_posts
          end
        end

        it "should get the number of posts specified" do 
          @site.link_list.length.should == @max_entries 
        end

        it "should return the correct URLs in the link_list array" do
          test_data = %w(http://squid314.livejournal.com/334537.html
                       http://squid314.livejournal.com/334269.html
                       http://squid314.livejournal.com/334048.html
                       http://squid314.livejournal.com/333628.html
                       http://squid314.livejournal.com/333353.html) 
                       @site.link_list.should <=> test_data
        end
      end

      context "when URL is inaccessible" do
        before(:each) do
          attributes = FactoryGirl.build(:url_search)
          @max_entries = attributes[:max_entries]
          @site = LinkExtractor.new(attributes)

          VCR.use_cassette('invalid_URL') do
            @site.get_posts
          end
        end
        it "should exit" do
          expect  { @site.process_page("randomtest.abcd") }.to raise_error
        end
      end

      context "cannot find the next page" do
        it "should return the first page of blog posts anyway" do
        end
      end
      context "posts cannot be found" do
        it "should exit" do
        end
      end
    end

    describe "searching via CSS" do
      context "all inputs are correct" do
        before(:each) do
          attributes = FactoryGirl.build(:css_search)
          @max_entries = attributes[:max_entries]
          @site = LinkExtractor.new(attributes)
          VCR.use_cassette('valid_css_search') do
            @site.get_posts
          end
        end

        it "should get the number of posts specified" do
          @site.link_list.length.should == @max_entries 
        end
        it "should return the correct URLs in the link_list array" do
          test_data = %w(http://googlereader.blogspot.com/2011/10/new-in-reader-fresh-design-and-google.html
                       http://googlereader.blogspot.com/2011/10/upcoming-changes-to-reader-new-look-new.html
                       http://googlereader.blogspot.com/2011/02/updates-to-google-reader-app-for.html
                       http://googlereader.blogspot.com/2011/01/more-control-over-comments-on-shared.html
                       http://googlereader.blogspot.com/2010/11/android-google-reader-app-is-here.html
                       http://googlereader.blogspot.com/2010/11/welcome-google-apps-users.html
                       http://googlereader.blogspot.com/2010/09/turning-off-track-changes-feature.html
                       http://googlereader.blogspot.com/2010/09/welcome-and-look-back.html
                       http://googlereader.blogspot.com/2010/08/fullscreen-and-more.html
                       http://googlereader.blogspot.com/2010/06/folder-and-tag-renaming.html
                        ) 
                        @site.link_list.should <=> test_data
        end

        context "URL is inaccessible" do
          it "should exit" do
          end
        end

        context "cannot find the next page" do
          it "should return the first page of blog posts" do
          end
        end

        context "posts cannot be found" do
          it "should exit" do
          end
        end
      end
    end
  end
end
