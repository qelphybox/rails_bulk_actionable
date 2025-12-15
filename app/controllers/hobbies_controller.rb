class HobbiesController < ApplicationController
  before_action :set_hobby, only: %i[ show edit update destroy ]

  # GET /hobbies
  def index
    @hobbies = Hobby.all
  end

  # GET /hobbies/1
  def show
  end

  # GET /hobbies/new
  def new
    @hobby = Hobby.new
  end

  # GET /hobbies/1/edit
  def edit
  end

  # POST /hobbies
  def create
    @hobby = Hobby.new(hobby_params)

    if @hobby.save
      redirect_to @hobby, notice: "Hobby was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /hobbies/1
  def update
    if @hobby.update(hobby_params)
      redirect_to @hobby, notice: "Hobby was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /hobbies/1
  def destroy
    @hobby.destroy!
    redirect_to hobbies_path, notice: "Hobby was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hobby
      @hobby = Hobby.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def hobby_params
      params.expect(hobby: [ :name ])
    end
end
