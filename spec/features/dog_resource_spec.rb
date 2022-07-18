require 'rails_helper'

describe 'Dog resource', type: :feature do
  context 'when user is owner' do
    before do 
      @user = create(:user)
      login_as(@user, scope: :user)
    end
    it 'can create a profile' do
      visit new_dog_path
      fill_in 'Name', with: 'Speck'
      fill_in 'Description', with: 'Just a dog'
      click_button 'Create Dog'
      expect(Dog.count).to eq(1)
    end

    it 'can edit a dog profile' do
      dog = create(:dog, owner: @user)
      visit edit_dog_path(dog)
      expect(page).not_to have_button('Like')
      fill_in 'Name', with: 'Speck'
      click_button 'Update Dog'
      expect(dog.reload.name).to eq('Speck')
    end

    it 'can delete a dog profile' do
      dog = create(:dog, owner: @user)
      visit dog_path(dog)
      click_link "Delete #{dog.name}'s Profile"
      expect(Dog.count).to eq(0)
    end
  end

  context 'when user is not owner' do
    before do 
      @user = create(:user)
      @user2 = create(:user)
      login_as(@user2, scope: :user)
    end

    it 'can Like dog' do
      dog = create(:dog, owner: @user)
      visit dog_path(dog)
      expect(page).to have_button('Like')
      click_button 'Like'
      expect(Like.last.dog).to eq(dog)
      visit dog_path(dog)
      expect(page).to have_selector("p", text: "You liked this dog.")
    end
  end
end
