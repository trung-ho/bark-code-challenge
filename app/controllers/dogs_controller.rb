class DogsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :new, :create, :destroy]
  before_action :set_dog, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_owner, only: [:edit, :update, :destroy]

  # GET /dogs
  # GET /dogs.json
  def index
    @newest_liked = Dog.left_joins(:likes).
      group(:id).order('COUNT(likes.id) DESC').
      where('likes.created_at > ?', 1.hours.ago)

    @other_dogs = Dog.all.where.not(id: @newest_liked.pluck(:id))
    @dogs = Kaminari.paginate_array(@newest_liked + @other_dogs).page(params[:page]).per(5)
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
    @like = @dog.likes.new
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = current_user.dogs.new(dog_params)

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dog
    @dog = Dog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dog_params
    params.require(:dog).permit(:name, :description, :images)
  end

  def authenticate_owner
    redirect_to root_path unless @dog.is_owner?(current_user)
  end
end
