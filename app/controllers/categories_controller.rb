class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @most_voted = Article.most_voted.includes(:category).includes(:author).last
    @most_recents = Article.latest_in_categories.includes(:category).includes(:author)
  end

  def show
    @category = Category.find(params[:id])
    @articles = @category.articles.merge(Article.most_recent_first).includes(:author).includes(:votes)
    init_page_name @category.name
  end
end
