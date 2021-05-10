require 'rails_helper'
require_relative '../support/shared/session'

feature 'Category List' do
  let(:user1) { User.create!(name: 'Francis') }
  let(:user2) { User.create!(name: 'Charles') }

  scenario 'all categories listed on home page' do
    categories = new_categories
    login user2.name
    visit root_path
    categories.each do |category|
      expect(page).to have_css('div', text: category.name, match: :prefer_exact)
    end
  end

  scenario 'older articles of each category NOT shown on home page' do
    categories = new_categories
    articles = create_generic_articles(categories, user2)
    create_articles(categories, user2)
    login user2.name
    visit root_path

    articles.each do |article|
      expect(page).to have_no_css('div', text: article.title, match: :prefer_exact)
    end
  end

  scenario 'latest article of each category shown on home page' do
    categories = new_categories
    create_generic_articles(categories, user2)
    articles = create_articles(categories, user2)

    login user2.name
    visit root_path

    articles.each do |article|
      expect(page).to have_css('div', text: article.title, match: :prefer_exact)
    end
  end
end

feature 'Most voted article' do
  let(:user1) { User.create!(name: 'Francis') }
  let(:user2) { User.create!(name: 'Charles') }

  scenario 'is displayed on home page' do
    categories = new_categories
    articles = create_generic_articles(categories, user1)
    create_articles(categories, user2)

    article = articles[0]
    login user2.name
    visit article_path(article)
    click_on(class: 'vote-link')

    visit root_path
    expect(page).to have_css('h3', text: article.title, match: :prefer_exact)
  end
end

feature 'show category' do
  let(:user) { User.create!(name: 'Francis') }

  scenario 'displays all articles in given category' do
    category = Category.create!(name: 'Category', priority: 1)
    articles = 6.times.map { |num| new_article(category, user, "Article Number #{num}") }

    login user.name
    visit category_path category

    articles.each { |article| expect(page).to have_css('h3', text: article.title, match: :prefer_exact) }
  end
end

def new_article(category, user, title = 'A Test Article')
  user.articles.create!(category_id: category.id, title: title, text: 'a' * 300, image: 'test.png')
end

def new_categories
  %w[Family Eduction Sports Culture].each_with_index.map { |n, i| Category.create!(name: n, priority: i) }
end

def create_generic_articles(categories, user)
  categories.map { |cat| new_article(cat, user) }
end

def create_articles(categories, user)
  categories.each_with_index.map { |cat, i| new_article(cat, user, "Article Title #{i}") }
end
