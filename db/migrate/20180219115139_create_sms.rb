class CreateSms < ActiveRecord::Migration[5.1]
  def change
    create_table :sms, id: :uuid do |t|
      t.string :message
      t.string :transport_mode
      t.string :phone_number
      t.string :current_location

      t.timestamps
    end
  end
end
