class PersonHobby < ApplicationRecord
  belongs_to :person
  belongs_to :hobby
end
