class Category < ApplicationRecord
  @@all_categories = nil

  has_many :articles

  validates :name, presence: true, uniqueness: true

  validates :priority, presence: true

  def self.names
    @@all_categories = self.all.order('priority').pluck(:name) if @@all_categories.nil?
    @@all_categories
  end
end
