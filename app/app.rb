ENV["RACK_ENV"] ||= "development"
# require 'data_mapper'
require 'sinatra/base'
require 'sinatra/flash'
require_relative 'data_mapper_setup'

# require './app/models/link'

class BookmarkManager < Sinatra::Base
   enable :sessions
   set :session_secret, 'super secret'

   register Sinatra::Flash

   get '/' do
     redirect 'links'
   end

  get '/links' do
    @links = Link.all
    @email = current_user.email if current_user
    erb :'/links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    tag = params[:tags].split
    tag.each { |tag| link.tags << Tag.first_or_create(name: tag) }
    link.save
    redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    @invalid_user = flash[:invalid_user?]
    @email = flash[:email]
    erb :'users/new'
  end

  post '/users' do
    user = User.create(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    session[:id] = user.id


    if user.valid?
      redirect to('/links')
    else
      flash[:invalid_user?] = true
      flash[:email] = params[:email]
      redirect to('/users/new')
    end
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:id])
    end
  end

end
