require 'rubygems'
require 'rack/test'
require 'webrat'
require 'test/unit'
require 'app'

Webrat.configure do |config|
  config.mode = :rack
end

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  def app
    Sinatra::Application.new
  end

  def setup
    file = File.new("recipes.store", "a+")
    file.close
  end

  def teardown
    File.delete("recipes.store")
  end

  def create_and_submit_recipe(title="Cherry Pie", recipe="Is the Best!")
    visit "/entry"
    fill_in "Title", :with => title
    fill_in "Recipe", :with => recipe
    click_button "Submit"
  end


  #TODO: create separate pstore for tests only?

  def test_it_works
    visit "/"
    assert_contain("Welcome to the Pie List!")
  end

  def test_form_entry
    title = "Apple Pie"
    recipe = "Put some apples in a crust and bake!"
    create_and_submit_recipe(title, recipe)
    assert_contain(title)
  end

  def test_first_recipe_still_exists_after_adding_second
    ["A", "C", "B", "Boo"].each do |e|
      create_and_submit_recipe(e, "recipe")
    end
    assert_contain("A")
    assert_contain("B")
    assert_contain("C")
    assert_contain("Boo")
  end

  #TODO
  #def test_recipes_are_alphabetized
  #end

  def test_link_from_list_to_entry
    visit "/"
    click_link "enter"

    assert_contain("Title")
    assert_contain("Recipe")
  end

  def test_link_from_list_to_recipe_page
    create_and_submit_recipe

    click_link "Cherry Pie"
    assert_contain "Is the Best!"
  end

  def test_link_from_recipe_to_list_page
    create_and_submit_recipe

    click_link "Cherry Pie"
    click_link "Back to Recipes"

    assert_contain("enter")
  end

  def test_cancel_link_on_entry_page
    visit "/"
    click_link "enter"

    click_link "Cancel"
    assert_contain("enter")
  end
end
