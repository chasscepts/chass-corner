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
      article1 = Article.create!(author_id: user.id, category_id: category.id, title: 'This is article 1', text: 'a' * 350, image: 'http://localhost')
      article2 = Article.create!(author_id: user.id, category_id: category.id, title: 'This is article 2', text: 'a' * 350, image: 'http://localhost')
      article_ids = category.articles.map(&:id)
      expect(category.articles.map(&:id)).to eq([article1.id, article2.id])
    end
  end
end
