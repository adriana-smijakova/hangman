class Word < ActiveRecord::Base
  belongs_to :category
  validates :content, presence: true
end
