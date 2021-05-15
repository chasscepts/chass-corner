require 'rails_helper'
require_relative '../support/matchers/not_talk_to_db'

RSpec.describe Category, type: :model do
  describe 'validation' do
    it 'fails when name is not unique' do
      Category.create(name: 'Family', priority: 1)
      expect(Category.new(name: 'Family', priority: 1).valid?).to be false
    end

    it 'fails when name is not presence' do
      expect(Category.new(priority: 1).valid?).to be false
    end

    it 'fails when priority is not presence' do
      expect(Category.new(name: 'Family').valid?).to be false
    end

    it 'passes for valid parameters' do
      expect(Category.new(name: 'Family', priority: 1).valid?).to be true
    end
  end

  describe 'associations' do
    let(:user) { User.create!(name: 'Francis') }
    let(:category) { Category.create!(name: 'Family', priority: 1) }

    it 'retrieves articles in a category' do
      article1 = cat_ms_create_article(user, category)
      article2 = cat_ms_create_article(user, category)
      expect(category.articles.map(&:id)).to eq([article1.id, article2.id])
    end

    it 'retrieves the latest article from each category' do
      categories = %w[Family Sport].each_with_index.map { |item, i| Category.create(name: item, priority: i) }
      categories.map do |category|
        cat_ms_create_article(user, category)
      end
      ids2 = categories.map do |category|
        cat_ms_create_article(user, category).id
      end

      expect(Category.with_latest_article.map(&:latest_article_id)).to eq(ids2)
    end
  end
end

def cat_ms_create_article(author, category)
  article = author.articles.create!(title: 'This is an Article', text: 'a' * 350, image: 'test.png')
  ArticleCategory.create!(article_id: article.id, category_id: category.id)
  article
end
