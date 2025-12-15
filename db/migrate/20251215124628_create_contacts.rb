class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :contacts do |t|
      t.references :person, null: false, foreign_key: true
      t.string :contact_type
      t.string :contact_value

      t.timestamps
    end
  end
end
