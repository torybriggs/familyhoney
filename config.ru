
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
    set :author,    "Tory Briggs"                             # blog author
    set :title,     "Family Honey"			                  # site title
  # set :root,      "index"                                   # page to load on /
  # set :date,      lambda {|now| now.strftime("%d/%m/%Y") }  # date format for articles
  # set :markdown,  :smart                                    # use markdown + smart-mode
  # set :disqus,    false                                     # disqus id, or false
    set :summary,   :max => 10000, :delim => /~/              # length of article summary and delimiter
  # set :ext,       'txt'                                     # file extension for articles
  # set :cache,      28800                                    # cache duration, in seconds

  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
end

# Redirect www to non-www
gem 'rack-rewrite', '~> 0.2.1'
require 'rack-rewrite'
if ENV['RACK_ENV'] == 'production'
    use Rack::Rewrite do
        r301 %r{.*}, 'http://familyhoney.com$&', :if => Proc.new {|rack_env|
        rack_env['SERVER_NAME'] != 'familyhoney.com'
    }
    end
end

run toto


