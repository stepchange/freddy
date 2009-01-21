require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'timeout'

get '/' do
  begin
    Timeout::timeout(15) do 
      "#{params['callback']}(#{open(params['url']).read})"
    end
  rescue Timeout::Error
    "#{params['callback']}({'error' : 'Requesting the json took too long. Time limit is 15 seconds.'})"
  end
end