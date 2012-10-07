require 'link_extractor'
require 'spec_helper'
require 'factory_girl'

describe LinkExtractor do

  FactoryGirl.find_definitions

  #expect { @site.get_posts }.to raise_error

  context "with a search via URL" do
    before(:each) do
      @site = FactoryGirl.build(:url_search)
    end

    describe "on a non-available page" do
      it "should raise an error" do
        expect { @site.get_posts }.to raise_error("URL not found")
      end

    end

    describe "on an available page" do

    end

  end

  context "with a search via CSS" do
    before(:each) do
      @site = FactoryGirl.build(:css_search)
    end

  end

  context "beginning attributes" do
    before(:each) do
      @site = FactoryGirl.build(:url_search)
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


end
