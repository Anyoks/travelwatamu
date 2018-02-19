class CreateTuktuks < ActiveRecord::Migration[5.1]
  def change
    create_table :tuktuks, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :number_plate
      t.string :phone_number
      t.string :stage
      t.boolean :status

      t.timestamps
    end
  end
end
