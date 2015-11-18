require 'oj'
require 'httparty'
require 'pry'
require 'erb'
require 'sinatra/base'
require 'sinatra/partial'

class UtiliDash < Sinatra::Base

  register Sinatra::Partial
  set :partial_template_engine, :haml
  enable :partial_underscores

  configure do
    mime_type :javascript, 'application/javascript'
    mime_type :javascript, 'text/javascript'
    set :logging, true
    set :static, true
  end

  def envoy_host
    ENV['ENVOY_HOST'] || nil
  end


  def enlighten_credentials
    if ENV['ENLIGHTEN_USER']
      {
        userid: ENV['ENLIGHTEN_USER'],
        apikey: ENV['ENLIGHTEN_KEY']
      }
    end
  end

  def to_bool(str)
    str.downcase == 'true'
  end

  def services_configured
    services = {}
    services.store( :envoy_host, envoy_host )           if envoy_host
    services.store( :enlighten, enlighten_credentials ) if enlighten_credentials
    return services
  end

  def production
    if envoy_host
      response = HTTParty.get( "http://#{envoy_host}/api/v1/production" )
      Oj.load response.body
    else
      # Just return stubdata
      {
        wattHoursToday:     0,
        wattHoursSevenDays: 0,
        wattHoursLifetime:  0,
        wattsNow:           0
      }
    end
  end

  helpers do
    def services
      services_configured
    end
  end

  get '/services_configured.json' do
    content_type :json
    services_configured.to_json
  end


  get '/' do
    haml :index
  end

  get '/realtime' do
    haml :realtime
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
