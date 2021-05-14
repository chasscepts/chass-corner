module ApplicationHelper
  def categories
    Category.all
  end

  def article_summary(article)
    "#{article.text[0...80]} ..." unless article.nil?
  end

  def home_menu_link(page)
    link_to 'Home', root_path, class: menu_class(page, 'Home')
  end

  def menu_links(page)
    safe_join(categories.map { |category| link_to category.name, category, class: menu_class(page, category.name) })
  end

  def user_action_links(user, page)
    box_wrapper('user_action_links') do
      if user.nil?
        "#{
          link_to 'Sign In', new_session_path, class: menu_class(page, 'Sign In')
        }
        <span class='separator'></span>
        #{
          link_to 'Register', new_user_path, class: menu_class(page, 'Register')
        }".html_safe
      else
        "#{
          link_to 'New Article', new_article_path, class: menu_class(page, 'New Article')
        }
        <span class='separator'></span>
        #{
          link_to 'Sign Out', session_path(user), method: :delete, class: menu_class(page, 'Sign Out')
        }".html_safe
      end
    end
  end

  def footer_social_media_links
    box_wrapper('d-flex align-items-center') do
      "
        <span class='text-light'>Connect with us: </span>
        #{safe_join(
          %w[twitter instagram facebook].map do |platform|
            link_to image_tag("iconfinder_#{platform}.svg", class: 'w-100 footer-media-icon'), root_path,
                    class: 'footer-media-link'
          end
        )}
      ".html_safe
    end
  end

  def render_notifications(notice, alert)
    safe_join(
      [{ content: notice, class: 'notice' }, { content: alert, class: 'alert' }].map do |item|
        box_wrapper(item[:class]) { box_wrapper('notification-inner') { item[:content] } } if item[:content]
      end
    )
  end

  def vote_link(article, user)
    return if user.nil? || user.id == article.author_id

    vote = article.votes.where(user_id: user.id).first
    box_wrapper 'media-link-wrap d-flex' do
      if vote.nil?
        link_to 'vote', article_votes_path(article), method: :post, class: 'media-link vote-link'
      else
        link_to 'unvote', article_vote_path(article, vote), method: :delete, class: 'media-link vote-link'
      end
    end
  end

  def box_wrapper(class_name, &block)
    content = capture(&block)
    content_tag(:div, content, class: class_name)
  end

  private

  def menu_class(page, menu)
    return 'menu-link' if page.nil?

    page == menu ? 'menu-link active' : 'menu-link'
  end
end
