
require 'toto'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

#
# Create and configure a toto instance
#
toto = Toto::Server.new do
  #
  # Add your settings here
  # set [:setting], [value]
  #
  # set :author,    ENV['USER']                               # blog author
  # set :root,      "index"                                   # page to load on /
  # set :date,      lambda {|now| now.strftime("%d/%m/%Y") }  # date format for articles
  # set :markdown,  :smart                                    # use markdown + smart-mode
  # set :disqus,    false                                     # disqus id, or false
  # set :summary,   :max => 150, :delim => /~/                # length of article summary and delimiter
  # set :ext,       'txt'                                     # file extension for articles
  # set :cache,      28800                                    # cache duration, in seconds

  set :title,       "Socrata Open Data API"
  set :date,        lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
  set :github,      {:user => "socrata", :repos => ['socrata-ruby'], :ext => 'textile'}
  set :disqus,      "dev-socrata-com"
end

# Add a few rack-redirect rules
gem 'rack-rewrite'
require 'rack-rewrite'
use Rack::Rewrite do
  # Toto really wants the root to be the blog, but we want to move it to /blog
  rewrite %r{/blog(.*)}, '/$1'
  r301 %r{(\d{4}/.*)}, '/blog/$1'

  # We want the root to be our "home" page
  rewrite '/', '/home'

  # Better endpoints for RSS and ATOM
  rewrite '/atom.xml', 'index.xml'
end

# Set up code highlighting
gem 'coderay'
require 'coderay'
gem 'rack-codehighlighter'
require 'rack/codehighlighter'

use Rack::Codehighlighter, :coderay,
  :markdown => true,
  :element => "pre>code",
  :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i,
  :logging => true

run toto

