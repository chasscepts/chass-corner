class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def new
    @categories = Category.all
    @article = Article.new
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

  private

    def article_params
      params.require(:article).permit([:title, :category_id, :text, :image])
    end
end
