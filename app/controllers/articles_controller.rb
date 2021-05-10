class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def new
    @categories = Category.all
    @article = Article.new
    init_page_name 'New Article'
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      redirect_to root_path, notice: 'Article Created'
    else
      @categories = Category.all
      render :new
    end
  end

  def show
    @article = Article.find(params[:id])
    init_page_name @article.category.name
  end

  private

  def article_params
    params.require(:article).permit(%i[title category_id text image])
  end
end
