class PeopleController < ApplicationController
  include BulkActionable

  before_action :set_person, only: %i[ show edit update destroy ]

  def index
    @scope = Person.all
    @q = @scope.ransack(params[:q])

    @pagy, @people = pagy(:offset, @q.result)
  end

  def bulk_destroy
    bulk_action_selected_items.find_each(&:destroy!)
    bulk_action_reset

    redirect_to people_path, notice: "Selected people were successfully destroyed.", status: :see_other
  end

  def show
  end

  def new
    @person = Person.new
    @person.contacts.build
    @hobbies = Hobby.all.order(:name)
  end

  def edit
    @person.contacts.build if @person.contacts.empty?
    @hobbies = Hobby.all.order(:name)
  end

  def create
    @person = Person.new(person_params)
    @hobbies = Hobby.all.order(:name)

    if @person.save
      redirect_to @person, notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @hobbies = Hobby.all.order(:name)
    puts "params: #{params[:person][:contacts_attributes]}"
    puts "person_params: #{person_params.to_h}"

    if @person.update(person_params)
      redirect_to @person, notice: "Person was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @person.destroy!
    redirect_to people_path, notice: "Person was successfully destroyed.", status: :see_other
  end

  private
    def set_person
      @person = Person.find(params.expect(:id))
    end

    def person_params
      params.require(:person).permit(
        :first_name,
        :last_name,
        :birth_date,
        hobby_ids: [],
        contacts_attributes: [ :id, :contact_type, :contact_value, :_destroy ]
      )
    end

    def bulk_action_scope
      Person.all
    end

    def bulk_action_id_param
      :id
    end
end
