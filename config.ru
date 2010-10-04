
require 'toto'
require 'cgi'
require 'ostruct'
require 'yaml'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end


#
# Create and configure a toto instance
#
toto = Toto::Server.new({
  # Horrible hack to add more things to the config
  :apps => YAML::load(File.open("config/apps.yml"))
}) do
  set :author,      "Chris Metcalf"
  set :title,       "Socrata Open Data API"
  set :date,        lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
  set :github,      {:user => "socrata", :repos => ['socrata-ruby'], :ext => 'textile'}
  set :disqus,      "dev-socrata-com"
  set :cache,       28800

  if ENV['RACK_ENV'] != "production"
    set :url, "http://localhost:3001"
  else
    set :url, "http://dev.socrata.com"
  end

  # Abandoned custom error page based on our template
  # set :error,  lambda { |code| ERB.new(File.read("templates/pages/errors/#{code}.rhtml")).result(Toto::Context.new({:code => code}, this)) }

  # Simple error page
  set :error, lambda { |code|
    case code
    when 404
      "These are not the droids you are looking for... (404)"
    when 500
      "I would much rather have gone with Master Luke than stay here with you. I don't know what all this trouble is about, but I'm sure it must be your fault. (500)"
    else
      "Hokey religions and ancient weapons are no match for a good blaster at your side, kid."
    end
  }

end

# I find Toto's default ERB helpers to be pretty lacking, so I've added a bunch
# of hacks...
class Toto::Site::Context
  # A hack to load "partials""
  def partial(name = nil, locals = {})
    klass = Class.new do
      attr_accessor :locals
      def initialize(locals)
        @locals = locals
      end
    end

    ERB.new(File.read("templates/pages/_#{name}.rhtml")).result(klass.new(locals).send(:binding))
  end

  # Get me an API docs link
  def docs(name)
    "http://www.socrata.com/api/docs/#{name}"
  end

  # Construct a "GET" link
  def get(path, class_name = "exec")
    "<a class=\"#{class_name}\" href=\"http://www.socrata.com/api#{path}\">get(\"#{path}\")</a>"
  end

  def apps
    if ENV['RACK_ENV'] == 'production' 
      @config[:apps]
    else
      # Always reload in development
      YAML::load(File.open("config/apps.yml"))
    end
  end

  def u(unescaped)
    CGI::escape(unescaped)
  end
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
  r302 '/feed/', 'http://feeds.feedburner.com/socrata-soda'
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

