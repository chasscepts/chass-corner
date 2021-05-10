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
end
