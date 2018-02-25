class CreateBtripRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :btrip_requests, id: :uuid do |t|
      t.string :phone_number
      t.string :location
      t.uuid   :bajaj_id
      t.string :status

      t.timestamps
    end
    add_index :btrip_requests, :bajaj_id
  end
end
