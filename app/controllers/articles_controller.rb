class ArticlesController < ApplicationController
  before_action :authenticate_user!

  def new
    @categories = Category.all
    @article = Article.new
    init_page_name 'New Article'
  end

  def create
    @article = current_user.articles.new(article_params)
    categories_ids = categories_list
    if categories_ids.size.zero?
      Flash.now[:notice] = 'Please select at least one category'
      @categories = Category.all
      render :new
    end
    if @article.save
      categories_ids.each { |category_id| ArticleCategory.create(article_id: @article.id, category_id: category_id) }
      redirect_to article_path(@article), notice: 'Article Created'
    else
      @categories = Category.all
      render :new
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  private

  def article_params
    params.require(:article).permit(%i[title text image])
  end

  def categories_list
    categories = []
    Category.all.each_with_object(categories) do |item, memo|
      id = params[:article][item.name]
      memo << id.to_i unless id.nil? || id.to_i.zero?
    end
    categories
  end
end
