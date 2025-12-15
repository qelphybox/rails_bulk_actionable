class Hobby < ApplicationRecord
  has_many :person_hobbies, dependent: :destroy
  has_many :people, through: :person_hobbies

  validates :name, presence: true, uniqueness: true
end
