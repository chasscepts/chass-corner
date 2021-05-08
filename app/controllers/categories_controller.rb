class CategoriesController < ApplicationController
  def index
    @most_voted = Article.most_voted.includes(:category).includes(:author).last
    @most_recents = Article.latest_in_categories.includes(:category).includes(:author)
  end

  def show
    @category = Category.find(params[:id])
    @articles = @category.articles.includes(:author).includes(:votes)
  end
end
