require 'open-uri'
require 'rubygems'
require 'securerandom'

module TrogScraper
  module HtmlGenerator

    def self.random_filename
      filename = "temp_" + SecureRandom.hex(13) + ".html"
      File.join('temp', filename)
    end

    def self.write_html_headers(filename)
      puts "Writing to #{filename}"
      puts Dir.pwd
      File.open(filename, "w") do |file|
        file.write "<html><head><title> Kindle Document </title> <meta http-equiv
        =\"Content-Type\" content=\"text/html;charset=utf-8\" /></head><body>"
      end
    end

    def self.write_html_ending(filename)
      File.open(filename, "a") do |file|
        file.write "</body></html>"
      end
    end

    def self.write_file(page_url, output_file, index)
      File.open(output_file, "a") do |file|
        source_page = open(page_url).read
        doc = ContentExtractor.new(source_page)
        file.write "<mbp:pagebreak />"
        file.write "<h3><a name=\"post-#{index+1}\">#{doc.title_info}</a></h3>"
        file.write "<h5>Page URL: "
        file.write page_url + "</h5>"
        file.write "<h5>Author: "
        file.write doc.author_info + "</h5>"
        file.write doc.content
      end
    end

    def self.create_html_file(link_list)
      output_file = random_filename
      write_html_headers(output_file)
      create_toc(output_file, link_list.length)
      link_list.each_with_index do |link, index|
        puts "Processing #{link}"
        write_file(link, output_file, index)
      end
      write_html_ending(output_file)
    end

    def self.create_toc(filename, index)
      File.open(filename, "a") do |file|
        file.write "<h3>Table of Contents</h3>"
        file.write "<br>"
        1.upto(index) do |i|
          file.write "<a href=\"#post-#{i}\">Post #{i}</a>"
          file.write "<br><br>"
        end
      end
    end
  end
end
