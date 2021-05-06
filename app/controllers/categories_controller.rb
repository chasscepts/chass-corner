class CategoriesController < ApplicationController
  def index
    @most_voted = Article.most_voted.includes(:category)
    @most_recents = Article.latest_in_categories.includes(:category)
  end

  def show
    @category = Category.find(params[:id])
    @articles = @category.articles
  end
end
