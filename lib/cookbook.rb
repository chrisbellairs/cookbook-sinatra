require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_filepath)
    @recipes = []
    CSV.foreach(csv_filepath) { |row| @recipes << Recipe.new(row[0], row[1], row[2], row[3], row[4]) }
    @csv_filepath = csv_filepath
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    CSV.open(@csv_filepath, "wb") do |csv|
      @recipes.each do |instance|
        csv << [instance.name, instance.description, instance.rating, instance.prep_time, instance.done]
      end
    end
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    CSV.open(@csv_filepath, "wb") do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, instance.rating, instance.prep_time, instance.done]
      end
    end
  end

  def mark_as_done(recipe_index)
    @recipes[recipe_index].mark_as_done
    CSV.open(@csv_filepath, "wb") do |csv|
      @recipes.each do |instance|
        csv << [instance.name, instance.description, instance.rating, instance.prep_time, instance.done]
      end
    end
  end
end
