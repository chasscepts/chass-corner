require 'rails_helper'

RSpec.describe Article, type: :model do
  context 'validations' do
    let(:author) { User.create!(name: 'Francis') }
    let(:category) { Category.create(name: 'Lifestyle', priority: 1) }

    it 'fails on author_id missing' do
      article = article_ms_new_article(nil, 'This is an article', 'a' * 350, 'test.png')
      expect(article.valid?).to be false
    end

    it 'fails on title missing' do
      article = article_ms_new_article(author.id, nil, 'a' * 350, 'test.png')
      expect(article.valid?).to be false
    end

    it 'fails on title too short' do
      article = article_ms_new_article(author.id, 'Thisisart', 'a' * 350, 'test.png')
      expect(article.valid?).to be false
    end

    it 'fails on text missing' do
      article = article_ms_new_article(author.id, 'This is an Article', nil, 'test.png')
      expect(article.valid?).to be false
    end

    it 'fails on text too short' do
      article = article_ms_new_article(author.id, 'This is an Article', 'a' * 209, 'test.png')
      expect(article.valid?).to be false
    end

    it 'passes with valid fields' do
      article = article_ms_new_article(author.id, 'This is an Article', 'a' * 350, 'test.png')
      expect(article.valid?).to be true
    end
  end

  context 'associations' do
    let(:user1) { User.create!(name: 'Francis') }
    let(:user2) { User.create!(name: 'Chass') }
    let(:user3) { User.create!(name: 'Charles') }
    let(:category) { Category.create!(name: 'Family', priority: 1) }
    let(:article) { create_article(user1, category, 'This is an article', 'a' * 350) }

    it "retrieves an article's votes" do
      vote1 = user2.votes.create!(article_id: article.id)
      vote2 = user3.votes.create!(article_id: article.id)
      expect(article.votes.map(&:id)).to eq([vote1.id, vote2.id])
    end
  end

  context 'most_voted_article scope' do
    let(:users) { %w[Francis Okwudili Obetta].map { |name| User.create!(name: name) } }
    let(:category) { Category.create!(name: 'Lifestyle', priority: 1) }

    it 'retrieves the article that has most votes' do
      articles = 3.times.map { create_article(users[0], category) }
      articles.each { |article| article.votes.create!(user_id: users[1].id) }
      articles[1].votes.create!(user_id: users[2].id)

      expect(Article.most_voted.last).to eq(articles[1])
    end
  end
end

def create_article(author, category, title = 'This is an Article', text = nil)
  text = 'a' * 300 if text.nil?
  article = author.articles.create!(title: title, text: text, image: 'test.png')
  ArticleCategory.create!(article_id: article.id, category_id: category.id)
  article
end

def article_ms_new_article(author_id, title, text, image)
  Article.new(author_id: author_id, title: title, text: text, image: image)
end
