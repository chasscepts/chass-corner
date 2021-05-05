require 'rails_helper'
require_relative '../support/matchers/not_talk_to_db.rb'

RSpec.describe Category, type: :model do
  describe 'validation' do
    it 'does not allow duplicate name' do
      Category.create(name: 'Family', priority: 1)
      expect(Category.new(name: 'Family', priority: 1).valid?).to be false
    end
  end

  describe 'names' do
    let(:names) { %w[Politics Family Sports] }

    before(:each) do
      categories = names.each_with_index.map { |name, index| { name: name, priority: index} }
      Category.create(categories)
    end

    # it 'connects to database during first call' do
      # expect(ActiveRecord::Base.connection).to receive(:exec_query).exactly(1).times
      # Category.names
      # expect(->() { Category.names }).to query_db(1)
    # end

    it 'caches result after first call' do
      Category.names
      expect(->() { Category.names }).to not_talk_to_db
    end

    it 'retrieves categories ordered by priority' do
      expect(Category.names).to eq(names)
    end
  end
end
