class RecipesController < ApplicationController
  load_and_authorize_resource
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :fork]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    # @recipe = Recipe.find(params[:id])
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
    @recipe.recipe_ingredients.build
    @recipe.steps.build
  end

  # GET /recipes/1/edit
  def edit
    @recipe.steps.build
    @recipe.recipe_ingredients.build
  end

  def fork
    @forked_recipe = @recipe.dup
    @forked_recipe.origin_id = @recipe.id

    respond_to do |format|
      if @forked_recipe.save
        format.html { redirect_to edit_recipe_path(@forked_recipe), notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @forked_recipe }
      else
        format.html { render :new }
        format.json { render json: @forked_recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipe_params
      params.require(:recipe).permit(:title, :recipe_description, :portions, :time, :difficulty, :nutritions, :recipe_image, steps_attributes: [:description, :position, :step_image, :_destroy], recipe_ingredients_attributes: [:ingredient_id, :quantity, :measure ])
    end
end
