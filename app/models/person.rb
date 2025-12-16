class Person < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :person_hobbies, dependent: :destroy
  has_many :hobbies, through: :person_hobbies

  accepts_nested_attributes_for :contacts, allow_destroy: true, reject_if: :all_blank

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birth_date, presence: true

  def age
    return nil unless birth_date.present?

    today = Date.today
    age = today.year - birth_date.year

    if today.month < birth_date.month || (today.month == birth_date.month && today.day < birth_date.day)
      age -= 1
    end

    age
  end

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new("||",
      parent.table[:first_name], parent.table[:last_name])
  end

  def self.ransackable_attributes(auth_object = nil)
    ["birth_date", "created_at", "first_name", "full_name", "id", "last_name", "updated_at"]
  end
end
