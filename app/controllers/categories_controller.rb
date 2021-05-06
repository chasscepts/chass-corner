class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @articles = @category.articles
    @most_popular = Vote.most_voted_article
  end
end
