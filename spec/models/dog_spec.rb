require "rails_helper"

RSpec.describe Dog, type: :model do
  before do 
    @user = create(:user)
    @user2 = create(:user)
  end
  context "#is_owners?" do
    it "return true if user is dog owner" do
      dog = create(:dog, owner: @user)
      expect(dog.is_owner? @user).to eq true
      expect(dog.is_owner? @user2).to eq false
    end

    it "return true if user can like owner" do
      dog = create(:dog, owner: @user)
      expect(dog.can_like_by? @user).to eq false
      expect(dog.can_like_by? @user2).to eq true
    end

    it "return true if user following dog" do
      dog = create(:dog, owner: @user)
      Like.create(dog: dog, user: @user2)
      expect(dog.reload.liked_by? @user2).to eq true
    end
  end
end