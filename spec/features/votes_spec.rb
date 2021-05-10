require 'rails_helper'
require_relative '../support/shared/session'

feature 'Vote' do
  let(:user1) { User.create!(name: 'Francis') }
  let(:user2) { User.create!(name: 'Charles') }
  let(:category) { Category.create!(name: 'Category', priority: 1) }
  let(:article) do
    user1.articles.create!(category_id: category.id, title: 'A test Article', text: 'a' * 300, image: 'test.png')
  end

  scenario 'users can vote' do
    login user2.name
    visit article_path(article)
    click_on(class: 'vote-link')

    expect(page).to have_text 'You successfully voted for this article.'
  end

  scenario 'users cannot vote the same article twice' do
    login user2.name
    visit article_path(article)
    click_on(class: 'vote-link')

    visit article_path(article)
    expect(page).to have_no_css '.vote-link'
  end

  scenario 'users cannot vote their own article' do
    login user1.name
    visit article_path(article)

    expect(page).to have_no_css '.vote-link'
  end
end
