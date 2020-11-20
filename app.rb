require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative 'lib/cookbook'
require_relative 'lib/recipe'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file = File.join(__dir__, 'lib/recipes.csv')
cookbook = Cookbook.new(csv_file)

get '/' do
  @recipes = cookbook.all
  erb :layout do
    erb :index
  end
end

get '/new' do
  erb :layout do
    erb :new
  end
end

post '/recipes' do
  cookbook.add_recipe(Recipe.new(params[:name], params[:description], params[:rating], params[:prep_time]))
  redirect '/'
end

get '/delete/:index' do
  cookbook.remove_recipe(params[:index].to_i)
  redirect '/'
end
