require 'oj'
require 'httparty'
require 'pry'
require 'erb'
require 'sinatra/base'

class UtiliDash < Sinatra::Base

  configure do
    mime_type :javascript, 'application/javascript'
    mime_type :javascript, 'text/javascript'
    set :logging, true
    set :static, true
  end

  def envoy_host
    ENV['ENVOY_HOST'] || 'localhost'
  end

  def to_bool(str)
    str.downcase == 'true'
  end

  def production
    response = HTTParty.get( "http://#{envoy_host}/api/v1/production" )
    json = Oj.load response.body
  end


  get '/' do
    erb :index
  end

  get '/production.json' do
    content_type :json
    production.to_json
  end

  error 404 do
    erb :'404'
  end

  not_found do
    status 404
    erb :'404'
  end

end
