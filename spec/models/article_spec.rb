require 'rails_helper'

RSpec.describe Article, type: :model do
  context 'validations' do
    let(:author) { User.create!(name: 'Francis') }
    let(:category) { Category.create(name: 'Lifestyle', priority: 1) }

    it 'fails on category_id missing' do
      expect(Article.new(author_id: author.id, title: 'This is an article', text: 'a' * 350,
                         image: 'http://localhost').valid?).to be false
    end

    it 'fails on author_id missing' do
      expect(Article.new(category_id: category.id, title: 'This is an article', text: 'a' * 350,
                         image: 'http://localhost').valid?).to be false
    end

    it 'fails on title missing' do
      expect(Article.new(author_id: author.id, category_id: category.id, text: 'a' * 350,
                         image: 'http://localhost').valid?).to be false
    end

    it 'fails on title too short' do
      expect(Article.new(author_id: author.id, category_id: category.id, title: 'Thisisart', text: 'a' * 350,
                         image: 'http://localhost').valid?).to be false
    end

    it 'fails on text missing' do
      expect(Article.new(author_id: author.id, category_id: category.id, title: 'This is an article',
                         image: 'http://localhost').valid?).to be false
    end

    it 'fails on text too short' do
      expect(Article.new(author_id: author.id, category_id: category.id, title: 'This is an article', text: 'a' * 209,
                         image: 'http://localhost').valid?).to be false
    end

    it 'passes with valid fields' do
      expect(Article.new(author_id: author.id, category_id: category.id, title: 'This is an article', text: 'a' * 350,
                         image: 'http://localhost').valid?).to be true
    end
  end

  context 'associations' do
    let(:user1) { User.create!(name: 'Francis') }
    let(:user2) { User.create!(name: 'Chass') }
    let(:user3) { User.create!(name: 'Charles') }
    let(:category) { Category.create!(name: 'Family', priority: 1) }
    let(:article) { Article.create!(author_id: user1.id, category_id: category.id, title: 'This is an article', text: 'a' * 350, image: 'http://localhost') }

    it "retrieves an article's votes" do
      vote1 = user2.votes.create!(article_id: article.id)
      vote2 = user3.votes.create!(article_id: article.id)
      expect(article.votes.map(&:id)).to eq([vote1.id, vote2.id])
    end
  end

  context 'latest_in_categories scope' do
    let(:user) { User.create!(name: 'Francis') }
    let(:categories) { %w[One Two Three].each_with_index.map { |n, i| Category.create!(name: n, priority: i) } }

    it 'retrieves the latest article from each category' do
      categories.map do |category|
        category.articles.create!(author_id: user.id, title: 'This is an article', text: 'a' * 350,
                                  image: 'http://localhost').id
      end
      ids2 = categories.map do |category|
        category.articles.create!(author_id: user.id, title: 'This is an article', text: 'a' * 350,
                                  image: 'http://localhost').id
      end
      expect(Article.latest_in_categories.map(&:id)).to eq(ids2)
    end
  end

  context 'most_voted_article scope' do
    let(:users) { %w[Francis Okwudili Obetta].map { |name| User.create!(name: name) } }
    let(:category) { Category.create!(name: 'Lifestyle', priority: 1) }

    it 'retrieves the article that has most votes' do
      articles = 3.times.map do
        category.articles.create!(author_id: users[0].id, title: 'This is a title', text: 'a' * 350,
                                  image: 'http://localhost')
      end
      articles.each { |article| article.votes.create!(user_id: users[1].id) }
      articles[1].votes.create!(user_id: users[2].id)

      expect(Article.most_voted.last).to eq(articles[1])
    end
  end
end
