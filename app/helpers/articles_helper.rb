module ArticlesHelper
  def categories_list(article)
    article.categories.map(&:name).join(', ')
  end

  def category_checkboxes(categories, form)
    safe_join(
      categories.map do |category|
        sym = category.name.to_sym
        box_wrapper 'category-checkbox-wrap' do
          "
          #{form.check_box sym, { checked: false }, category.id, 0}
          #{form.label sym, category.name}
          ".html_safe
        end
      end
    )
  end
end
