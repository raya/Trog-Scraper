require 'ruby-readability'
require 'content_extractor'

describe ContentExtractor do
  context "reading a valid document" do
    before(:each) do
      @body =  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum sit amet diam risus. Pellentesque vehicula pretium massa, in hendrerit purus adipiscing et. Fusce in fringilla tellus. Vestibulum nec nunc vel."
      @ending = "</body></html>"
      @sample_doc = "<html><head><title>Generic Title</title></head><body>" + @body + @ending
      @site = ContentExtractor.new(@sample_doc)
    end

    specify { @site.title_info.should == "Generic Title" }
    specify { @site.content.gsub(/(<\/?div>)/,'').should == @body }
    specify { @site.author_info.should == "Unknown" }
  end

end
