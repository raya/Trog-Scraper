Gem::Specification.new do |s| 
  s.name         = "Trog_Scraper"
  s.version      = "0.0.1"
  s.author       = "Raya Desawade"
  s.email        = "rayalynn@gmail.com"
  s.summary      = "Scrapes the content of a website using Nokogiri and
                    Readability, then inserts that data into an HTML file
                    for conversion by the Kindlegen program"
  s.description  = File.read(File.join(File.dirname(__FILE__), 'README.md'))

  s.files         = Dir["{bin,lib,spec}/**/*"] + %w(README.md)
  s.test_files    = Dir["spec/**/*"]
  s.executables   = [ 'trog_scraper' ]

  s.required_ruby_version = '>=1.9'
  s.add_dependency("nokogiri", "~>1.5.5")
  s.add_dependency("ruby-readability", "~>0.5.5") 
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'factory-girl'
end
