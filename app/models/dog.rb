class Dog < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :likes
  has_many :followers, through: :likes, source: :user
  has_many_attached :images
  paginates_per 5

  def is_owner? user
    owner == user
  end

  def can_like_by? user
    owner != user
  end

  def liked_by? user
    followers.include?(user)
  end
end
