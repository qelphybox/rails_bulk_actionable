Person.destroy_all
Hobby.destroy_all
Contact.destroy_all
PersonHobby.destroy_all

puts "Creating hobbies..."
hobbies = []
150.times do |i|
  hobbies << Hobby.create!(name: Faker::Hobby.unique.activity)
end
puts "Created #{hobbies.count} hobbies"

puts "Creating people..."
people = []
1000.times do |i|
  people << Person.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 80)
  )
end
puts "Created #{people.count} people"

puts "Connecting people with hobbies..."
# Каждый человек владеет 10 хобби
people.each do |person|
  start_index = person.id % 150
  10.times do |offset|
    hobby_index = (start_index + offset) % 150
    PersonHobby.create!(
      person: person,
      hobby: hobbies[hobby_index]
    )
  end
end
puts "Connected people with hobbies"

puts "Creating contacts..."
# У каждого человека по 2 контакта
people.each do |person|
  2.times do
    contact_type = [ "email", "phone" ].sample
    contact_value = contact_type == "email" ? Faker::Internet.email : Faker::PhoneNumber.phone_number
    Contact.create!(
      person: person,
      contact_type: contact_type,
      contact_value: contact_value
    )
  end
end
puts "Created #{Contact.count} contacts"
