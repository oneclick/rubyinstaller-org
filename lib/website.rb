require "sinatra/base"
require "helpers"

class Website < Sinatra::Base
  include Helpers

  set :root,      File.expand_path("../../", __FILE__)
  set :website,   "RubyInstaller for Windows"

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
    also_reload "#{root}/lib/helpers.rb"
  end

  get "/" do
    erb :index, :layout => :frontpage
  end

  get "/about" do
    section :about
    title "About the project"

    erb :about
  end

  get "/downloads" do
    section :downloads
    title "Downloads"

    erb :releases, :locals => { :releases => [] }
  end

  get "/downloads/archives" do
    section :downloads
    title "Archives"

    erb :releases, :locals => { :releases => [] }
  end
end
