class Dog < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  paginates_per 5
end
