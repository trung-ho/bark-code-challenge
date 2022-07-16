class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes.new(dog_id_params)
    if @like.save
      redirect_to @like.dog
    end
  end

  private

  def dog_id_params
    params.permit(:dog_id)
  end
end
