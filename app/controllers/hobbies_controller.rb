class HobbiesController < ApplicationController
  include BulkActionable

  before_action :set_hobby, only: %i[ show edit update destroy ]

  def index
    @pagy, @hobbies = pagy(:offset, Hobby.all)
  end

  def bulk_destroy
    bulk_action_selected_items.find_each(&:destroy!)
    bulk_action_reset

    redirect_to hobbies_path, notice: "Selected hobbies were successfully destroyed.", status: :see_other
  end

  def show
  end

  def new
    @hobby = Hobby.new
  end

  def edit
  end

  def create
    @hobby = Hobby.new(hobby_params)

    if @hobby.save
      redirect_to @hobby, notice: "Hobby was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @hobby.update(hobby_params)
      redirect_to @hobby, notice: "Hobby was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @hobby.destroy!
    redirect_to hobbies_path, notice: "Hobby was successfully destroyed.", status: :see_other
  end

  private
    def set_hobby
      @hobby = Hobby.find(params.expect(:id))
    end

    def hobby_params
      params.expect(hobby: [ :name ])
    end

    def bulk_action_scope
      Hobby.all
    end

    def bulk_action_id_param
      :id
    end
end
