require 'rubygems'
require 'sinatra'
require 'open-uri'

get '/' do
  "#{params['callback']}(#{open(params['js']).read})"
end