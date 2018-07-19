class CreateDuplicateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :duplicate_messages, id: :uuid do |t|
    	t.string :message
    	t.string :transport_mode
    	t.string :phone_number
    	t.string :current_location
    	t.uuid   :sms_id
      t.timestamps
    end

    add_index :duplicate_messages, :sms_id
  end
end
