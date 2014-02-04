require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'timeout'


get '/' do
  begin
    if !params['url'] || !params['callback']
      "#{params['callback']}({'error' : 'Must include both 'url' and 'callback' parameters.'})"
    elsif params['url'].empty? || params['callback'].empty?
      "#{params['callback']}({'error' : 'Must include a value for both 'url' and 'callback' parameters.'})"
    else
      Timeout::timeout(3) do 
        "#{params['callback']}(#{open(params['url']).read})"
      end      
    end
  rescue Timeout::Error
    "#{params['callback']}({'error' : 'Requesting the json took too long. Time limit is 15 seconds.'})"
  rescue Errno::ENOENT => e
    "#{params['callback']}({'error' : 'Problem requesting the json: #{e}'})"
  end
end

get '/aggregate' do
  begin
    if !params['url'] || !params['callback']
      "#{params['callback']}({'error' : 'Must include both 'url' and 'callback' parameters.'})"
    elsif params['url'].empty? || params['callback'].empty?
      "#{params['callback']}({'error' : 'Must include a value for both 'url' and 'callback' parameters.'})"
    else
      Timeout::timeout(15) do 
        "#{params['callback']}({#{params['url'].map { |k,v| "#{k.inspect}: #{open(v).read}" }.join(',')}})"
      end      
    end
  rescue Timeout::Error
    "#{params['callback']}({'error' : 'Requesting the json took too long. Time limit is 15 seconds.'})"
  rescue Errno::ENOENT => e
    "#{params['callback']}({'error' : 'Problem requesting the json: #{e}'})"
  end
end
