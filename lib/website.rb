require "sinatra/base"

class Website < Sinatra::Base
  set :root,     File.expand_path("../../", __FILE__)

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
  end

  get "/" do
    erb :index
  end
end
