require 'optparse'

module ParseConfig
  def self.parse(args)
    options = {}
    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: html_downloader.rb --url --entries_to_dl --next_page_matcher --post_matcher --starting_page --starting_page_increment"
      opts.separator " "
      opts.on('--version', 'Version number') do
        puts ".10"
        exit
      end
      opts.on("--url page_url", String, :required, "the URL to parse") do |f|
        options[:page_url] = f.to_s
      end
      opts.on("--max max_entries", Integer, :required, "maximum number of posts to download") do |f|
        options[:max_entries] = f
      end
      opts.on('--next next_post_matcher', String, :required, "URL string or CSS for engine
          to find the blog's next page") do |f|
        options[:next_page_matcher] = f
          end      
      opts.on('--post post_matcher', String, :required, "URL string or CSS for engine
          to find a blog post") do |f|
        options[:post_matcher] = f
          end
      opts.on('--start starting_page', Integer, :required, "Page number to start on") do |f|
        options[:starting_page] = f
      end
      #TODO - set this to -1 automatically if detecting div in next_post_matcher
      opts.on('--inc starting_page_incrementor', Integer, :required, "Grab next X entries.
          Set to -1 if searching by CSS") do |f|
        options[:starting_page_incrementor] = f
          end
    end

    #Code from http://stackoverflow.com/questions/1541294/how-do-you-specify-a-required-switch-not-argument-with-ruby-optionparser
    begin
      optparse.parse!
      required = [:page_url, :max_entries, :next_page_matcher,
        :post_matcher, :starting_page, :starting_page_incrementor]
      missing = required.select { |param| options[param].nil? }
      if !missing.empty?
        puts "The following required options are missing: #{missing.join(', ')}\n\n"
        puts optparse.banner
        exit
      end
      return options
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument
      puts $!.to_s
      puts optparse.banner
      exit
    end
  end
end
