class Dog < ApplicationRecord
  has_many_attached :images
  paginates_per 5
end
