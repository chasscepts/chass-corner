require 'rails_helper'
require_relative '../support/matchers/not_talk_to_db.rb'

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
end
