class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @most_voted = Article.most_voted.includes(%i[categories author]).last
    @categories = Category.with_latest_article.includes(:latest_article)
  end

  def show
    @category = Category.find(params[:id])
    @articles = @category.articles.merge(Article.most_recent_first).includes(%i[author votes])
    init_page_name @category.name
  end
end
