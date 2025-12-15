class Person < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :person_hobbies, dependent: :destroy
  has_many :hobbies, through: :person_hobbies

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birth_date, presence: true
end
