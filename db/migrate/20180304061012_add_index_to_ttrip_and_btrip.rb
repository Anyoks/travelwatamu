class AddIndexToTtripAndBtrip < ActiveRecord::Migration[5.1]
  def change

  	remove_index :btrips, :btrip_request_id
    remove_index :ttrips, :ttrip_request_id

    add_index :btrips, :btrip_request_id,  unique: true
    add_index :ttrips, :ttrip_request_id,  unique: true
  end
end
