#!/usr/bin/env ruby

#require 'open-uri'
#require 'rubygems'
#require 'securerandom'
require 'optparse'

require_relative '../lib/content_extractor'
require_relative '../lib/link_extractor'
require_relative '../lib/parse_config'
require_relative '../lib/html_generator'

options = ParseConfig.parse(ARGV)
site = LinkExtractor.new(options)
site.get_posts
HtmlGenerator.create_html_file(site.link_list)

