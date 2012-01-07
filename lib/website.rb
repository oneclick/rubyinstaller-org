require "sinatra/base"
require "helpers"
require "models"
require "decorators"

class Website < Sinatra::Base
  include Helpers

  set :root,      File.expand_path("../../", __FILE__)
  set :website,   "RubyInstaller for Windows"

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
    also_reload "#{root}/lib/helpers.rb"
    also_reload "#{root}/lib/models.rb"
    also_reload "#{root}/lib/decorators.rb"

    # FIXME: in development, reload release information on every request
    before do
      Release.reload!
    end
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

    # Build list of featured releases, first Ruby then DevKit
    releases = Release.featured_ruby
    releases.concat Release.featured_devkit

    decorated = releases.map { |r| Decorators::Release.new(r) }

    erb :releases, :locals => { :releases => decorated }
  end

  get "/downloads/archives" do
    section :downloads
    title "Archives"

    erb :releases, :locals => { :releases => [] }
  end
end
