class AddRecipeDesriptionToRecipes < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :recipe_description, :text
  end
end
