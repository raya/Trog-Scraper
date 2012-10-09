Website2Mobi
============

A ruby program which has will grab blog posts and write them to an .html file formatted for Amazon's kindlegen program.

Usage
=====
Run html_downloader.rb in the /bin directory. It takes the following
required arguments:
* --url Link to the blog index you wish to extract data from. In many blogs, this will be the home page.
* --max The maximum number of posts you wish to grab.
* --next Either a script or css tag which the parser can use to find the previous page in the index. For example, the URL for tumblr blogs will be /page/. The
link extractor will then try to find the next page of links to grab at someblog.com/page/2.
If a blog does not support the format of script/page_number then a CSS attribute/tag can be used. For example, on many blogspot.com blogs, the link to the
previous page in the index will be "h3#post-title.entry-title a". The CSS submitted must be a unique entry.
* --start The starting page for the index if searching by script. Set to -1 if searching by CSS.
* --inc The number of entries to search by. Set to -1 if searching by URL.

Examples
========
ruby html_downloader.rb --url http://someblog.blogspot.com --max 5 --next "a.blog-pager-older-link" --post "h3.post-title.entry-title a" --start -1 --inc -1


Tests
=====
Forthcoming.

