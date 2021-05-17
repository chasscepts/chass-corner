require 'rails_helper'
require_relative '../support/shared/session'

feature 'Vote' do
  let(:user1) { User.create!(name: 'Francis') }
  let(:user2) { User.create!(name: 'Charles') }
  let(:category) { Category.create!(name: 'Category', priority: 1) }
  let(:article) { votes_fs_new_article(user1, category, 'A test Article') }

  scenario 'users can vote' do
    login user2.name
    visit article_path(article)
    click_on(class: 'vote-link')

    expect(page).to have_text 'You successfully voted for article.'
  end

  scenario 'users can unvote article' do
    login user2.name
    visit article_path(article)
    click_on(class: 'vote-link')

    visit article_path(article)
    click_on(class: 'vote-link')

    expect(page).to have_text 'You successfully unvoted article.'
  end

  scenario 'users cannot vote their own article' do
    login user1.name
    visit article_path(article)

    expect(page).to have_no_css '.vote-link'
  end

  def votes_fs_new_article(user, category, title)
    article = user.articles.create!(title: title, text: 'a' * 300, image: 'test.png')
    ArticleCategory.create!(article_id: article.id, category_id: category.id)
    article
  end
end
