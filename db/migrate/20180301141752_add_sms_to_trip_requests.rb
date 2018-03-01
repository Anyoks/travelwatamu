class AddSmsToTripRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :btrip_requests, :sms_id, :uuid
    add_column :ttrip_requests, :sms_id, :uuid

    add_index :btrip_requests, :sms_id,  unique: true
    add_index :ttrip_requests, :sms_id,  unique: true
  end
end
