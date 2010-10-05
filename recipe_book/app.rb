require 'rubygems'
require 'sinatra'
require 'pstore'

helpers do
  def store
    @store ||= ARGV[0]? PStore.new(ARGV[0]) : PStore.new("recipes.store")
  end

  def to_uri(str)
    str.gsub(" ", "-")
  end

  def to_title(str)
    str.gsub("-", " ")
  end
end

post "/" do
  @recipe = params[:Recipe]
  @title = params[:Title]
  erb :recipes
end

get "/" do
  erb :recipes
end

get "/entry" do
  erb :entry
end

get "/:recipe" do
  @recipe = params[:recipe]
  erb :recipe
end

