class Person < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :person_hobbies, dependent: :destroy
  has_many :hobbies, through: :person_hobbies

  accepts_nested_attributes_for :contacts, allow_destroy: true, reject_if: :all_blank

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birth_date, presence: true
end
