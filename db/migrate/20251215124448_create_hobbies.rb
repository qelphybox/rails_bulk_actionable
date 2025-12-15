class CreateHobbies < ActiveRecord::Migration[8.1]
  def change
    create_table :hobbies do |t|
      t.string :name

      t.timestamps
    end
    add_index :hobbies, :name, unique: true
  end
end
