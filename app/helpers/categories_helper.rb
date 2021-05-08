module CategoriesHelper
  def article_short_summary(article)
    article.text[0...30]
  end

  def category_links(articles)
    safe_join(articles.map { |article| render 'category_link', article: article })
  end
end
