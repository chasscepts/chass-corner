module ApplicationHelper
  def categories
    Category.all
  end

  def menu_links
    safe_join(categories.map { |category| render 'menu_link', category: category })
  end

  def user_action_links(user)
    box_wrapper('user_action_links') do
      if user.nil?
        "#{
          link_to 'Sign in', new_session_path
        }
        #{
          link_to 'Register', new_user_path
        }".html_safe
      else
        "#{
          link_to 'New Article', new_article_path
        }
        #{
          link_to 'Sign out', session_path(user), method: :destroy
        }".html_safe
      end
    end
  end

  private

  def box_wrapper(class_name, &block)
    content = capture(&block)
    content_tag(:div, content, class: class_name)
  end
end
