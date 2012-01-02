require "sinatra/base"

class Website < Sinatra::Base
  set :root,      File.expand_path("../../", __FILE__)
  set :website,   "RubyInstaller for Windows"

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
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

  def section(name = nil)
  end

  def title(value = nil)
    @title = value if value
    @title ? @title : ""
  end

  def page_title
    @title ? "#{@title} ~ #{settings.website}" : settings.website
  end

  def container(value = nil)
    @container = value if value
    @container ? "cols-#{@container}" : "cols-sidenav"
  end
end
