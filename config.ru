require "rubygems"
require "bundler/setup"

require "rack"

# fallback 404 response
run lambda{ |_| [ 302, {"Location"=> "http://dev.socrata.com#{_["PATH_INFO"]}" }, [] ] }
