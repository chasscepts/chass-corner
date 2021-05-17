require 'rails_helper'

RSpec.describe Vote, type: :model do
  context 'validation' do
    let(:user1) { User.create(name: 'Francis') }
    let(:user2) { User.create(name: 'Charles') }
    let(:category) { Category.create(name: 'Category', priority: 1) }
    let(:article) do
      user1.articles.create(title: 'This is an Article', text: 'a' * 350,
                            image: 'http://localhost')
    end

    it 'can vote on Article' do
      expect(user2.votes.new(article_id: article.id).valid?).to be true
    end

    it 'cannot vote twice on the same Article' do
      user2.votes.create(article_id: article.id)
      expect(user2.votes.new(article_id: article.id).valid?).to be false
    end
  end
end
