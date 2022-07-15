class Dog < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many_attached :images
  paginates_per 5

  def is_owner? user
    owner == user
  end
end
