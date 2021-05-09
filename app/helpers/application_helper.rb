module ApplicationHelper
  def categories
    Category.all
  end

  def article_summary(article)
    "#{article.text[0...150]} ..." unless article.nil?
  end

  def menu_links
    safe_join(categories.map { |category| render 'menu_link', category: category })
  end

  def user_action_links(user)
    box_wrapper('user_action_links') do
      if user.nil?
        "#{
          link_to 'Sign in', new_session_path, class: 'menu-link'
        }
        <span class='separator'></span>
        #{
          link_to 'Register', new_user_path, class: 'menu-link'
        }".html_safe
      else
        "#{
          link_to 'New Article', new_article_path, class: 'menu-link'
        }
        <span class='separator'></span>
        #{
          link_to 'Sign out', session_path(user), method: :delete, class: 'menu-link'
        }".html_safe
      end
    end
  end

  def footer_social_media_links
    box_wrapper('d-flex align-items-center') do
      "
        <span class='text-light'>Connect with us: </span>
        #{safe_join(
          %w[twitter instagram facebook].map { |platform| link_to image_tag("iconfinder_#{platform}.svg", class: 'w-100 footer-media-icon'), root_path, class: 'footer-media-link' }
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
    return if user.nil? || user.id == article.author_id || article.votes.map(&:user_id).include?(user.id)
    box_wrapper 'media-link-wrap' do
      link_to 'ote', article_votes_path(article), method: :post, class: 'media-link vote-link'
    end
  end

  def box_wrapper(class_name, &block)
    content = capture(&block)
    content_tag(:div, content, class: class_name)
  end
end
