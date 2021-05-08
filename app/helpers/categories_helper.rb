module CategoriesHelper
  def article_short_summary(article)
    article.text[0...30]
  end

  def category_links(articles)
    safe_join(articles.map { |article| render 'category_link', article: article })
  end

  def article_list(category, articles)
    safe_join(
      articles.each_with_index.map do |article, index|
        wrapper_class = 'article-summary-wrapper'
        wrapper_class = "#{wrapper_class} reverse" if index % 4 == 2 || index % 4 == 3
        box_wrapper wrapper_class do
          "#{image_tag(article.image, class: 'article_summary_image')}
          #{render 'article_summary', category: category, article: article, class_name: 'article-summary w-100'}".html_safe
        end
      end
    )
  end

  def vote_link(article, user)
    return if user.nil? || user.id == article.author_id || article.votes.map(&:user_id).include?(user.id)
    link_to 'ote', article_votes_path(article), method: :post, class: 'media-link vote-link'
  end
end
