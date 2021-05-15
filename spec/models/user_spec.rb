require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validating name' do
    it 'fails when provided' do
      expect(User.new.valid?).to be false
    end

    it 'fails when length is less than 2' do
      expect(User.new(name: 'O').valid?).to be false
    end

    it 'fails when username exists' do
      name = 'Francis'
      User.create!(name: name)
      expect(User.new(name: name).valid?).to be false
    end

    it 'passes when length is 2' do
      expect(User.new(name: 'OZ').valid?).to be true
    end

    it 'passes when length greater than 2' do
      expect(User.new(name: 'OZa').valid?).to be true
    end
  end

  context 'associations' do
    let(:user) { User.create!(name: 'Francis') }
    let(:category) { Category.create!(name: 'Family', priority: 1) }

    it "retrieves a user's articles" do
      article1 = Article.create!(author_id: user.id, title: 'This is article 1', text: 'a' * 350, image: 'http://localhost')
      article2 = Article.create!(author_id: user.id, title: 'This is article 2', text: 'a' * 350, image: 'http://localhost')
      expect(user.articles.map(&:id)).to eq([article1.id, article2.id])
    end

    it "retrieves a user's votes" do
      article1 = Article.create!(author_id: user.id, title: 'This is article 1', text: 'a' * 350, image: 'http://localhost')
      article2 = Article.create!(author_id: user.id, title: 'This is article 2', text: 'a' * 350, image: 'http://localhost')
      user2 = User.create!(name: 'Chass')
      vote1 = user2.votes.create!(article_id: article1.id)
      vote2 = user2.votes.create!(article_id: article2.id)
      expect(user2.votes.map(&:id)).to eq([vote1.id, vote2.id])
    end
  end
end
