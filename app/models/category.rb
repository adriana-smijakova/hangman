class Category < ActiveRecord::Base
  has_many :words
  validates :name, presence: true
  validates_uniqueness_of :name
end
