require 'rubygems'
require 'sinatra'
require 'pstore'

helpers do
  def store
    @store ||= ARGV[0]? PStore.new(ARGV[0]) : PStore.new("recipes.store")
  end

  attr_writer :store

  def recipe_list
    recipes = store.transaction { store.roots }
    recipes.sort
  end

  def to_uri(str)
    str.gsub(" ", "-")
  end

  def to_title(str)
    str.gsub("-", " ")
  end

  def retrieve_recipe(recipe)
    store.transaction { store[recipe] }
  end
end

post "/" do
  @recipe = params[:recipe]
  @title = params[:title]
  if @title
    store.transaction { store[@title] = @recipe }
  end
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
  @title = to_title(@recipe)
  erb :recipe
end

