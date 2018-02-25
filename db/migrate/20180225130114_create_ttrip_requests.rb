class CreateTtripRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :ttrip_requests, id: :uuid do |t|
      t.string :phone_number
      t.string :location
      t.uuid   :tuktuk_id
      t.boolean :status

      t.timestamps
    end
  end
end
