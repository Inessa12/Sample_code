class CategoriesController < ApplicationController

  before_filter :login_required

  def index
    @categories = Category.top_level
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new(params[:category])
  end

  def create
    @category = Category.new(params[:category])
    @success = @category.save

    render :update do |page| 
      if @success
        parent = params[:category][:parent_category]
        if parent
          # this is a subcategory, replace just a cat li
          page.replace_html "category_#{parent}", 
                            :partial => 'categories/parent_category', 
                            :locals => { :c => Category.find(parent) }
        else
          # this is a top level cat, replace the whole ul, reshow the create link
          page.replace_html "all_categories", 
                            :partial => 'categories/categories', 
                            :locals => { :categories => Category.top_level }
          page[:category_create].show
        end
      else
        # TODO flash an error
      end
    end
  end

  def destroy
    category = Category.find(params[:id])
    category.subcategories.map { |sc| sc.destroy }
    category.destroy
    redirect_to categories_path
  end

end
