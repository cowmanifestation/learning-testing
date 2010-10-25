require 'rubygems'
require 'rack/test'
require 'webrat'
require 'test/unit'
require 'contest'
require 'app'

Webrat.configure do |config|
  config.mode = :rack
end

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
  #include Webrat::HaveTagMatcher

  def app
    Sinatra::Application.new
  end

  setup do
    ARGV[0] = "test.store"
    file = File.new("test.store", "a+")
    file.close
  end

  teardown do
    File.delete("test.store")
  end

  def create_and_submit_recipe(title="Cherry Pie", recipe="Is the Best!")
    visit "/entry"
    fill_in "title", :with => title
    fill_in "recipe", :with => recipe
    click_button "Submit"
  end

  test "can access home page" do
    visit "/"
    assert_contain("Welcome to the Cookbook!")
  end

  test "can create recipe" do
    title = "Apple Pie"
    recipe = "Put some apples in a crust and bake!"
    create_and_submit_recipe(title, recipe)
    assert_contain(title)
  end

  test "first recipe still exists after adding second" do
    ["A", "C", "B", "Boo"].each do |e|
      create_and_submit_recipe(e, "recipe")
    end
    assert_contain("A")
    assert_contain("B")
    assert_contain("C")
    assert_contain("Boo")
  end

  test "recipe list is in alphabetical order" do
    create_and_submit_recipe
    create_and_submit_recipe("Apple Pie", "Is only good when Lynn makes it.")
    assert_have_xpath "//ul/li[1][a='Apple Pie']"
    assert_have_xpath "//ul/li[2][a='Cherry Pie']"
  end

  test "link from list to entry" do
    visit "/"
    click_link "enter"

    assert_contain("Title")
    assert_contain("Recipe")
  end

  test "link from list to recipe page" do
    create_and_submit_recipe

    click_link "Cherry Pie"
    assert_contain "Is the Best!"
  end

  test "link from recipe to list page" do
    create_and_submit_recipe

    click_link "Cherry Pie"
    click_link "Back to Recipes"

    assert_contain("enter")
  end

  test "cancel link on entry page" do
    visit "/"
    click_link "enter"

    click_link "Cancel"
    assert_contain("enter")
  end
end
