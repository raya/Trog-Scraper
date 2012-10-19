require 'ruby-readability'

module TrogScraper
  class ContentExtractor

    def initialize(source_page)
      @doc = Readability::Document.new(source_page)
    end

    def includes_author?
      !@doc.author.nil? 
    end

    def author_info
      if includes_author?
        @doc.author 
      else
        "Unknown" 
      end
    end

    def includes_title?
      !@doc.title.nil?
    end

    def title_info
      if includes_title?
        @doc.title
      else
        "Unknown"
      end
    end

    def content
      @doc.content
    end

  end
end
