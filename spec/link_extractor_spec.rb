require 'link_extractor'
require 'spec_helper'
require 'factory_girl'

describe LinkExtractor do

  FactoryGirl.find_definitions

  describe "searching via URL" do

    context "all inputs are correct" do
      before(:each) do
        attributes = FactoryGirl.build(:url_search)
        @max_entries = attributes[:max_entries]
        @site = LinkExtractor.new(attributes)
      end

      it "should get the number of posts specified" do
        @site.get_posts
        @site.link_list.length.should == @max_entries 
      end
      it "should return the correct URLs in the link_list array" 
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

  describe "searching via CSS" do
    context "all inputs are correct" do
      before(:each) do
        attributes = FactoryGirl.build(:css_search)
        @site = LinkExtractor.new(attributes)
      end

      it "should get the number of posts specified" do
        @site.get_posts
        @site.link_list.length.should == 5
      end
      it "should return the correct URLs in the link_list array" 
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
