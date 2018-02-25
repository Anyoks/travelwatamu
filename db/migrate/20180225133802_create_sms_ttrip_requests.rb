class CreateSmsTtripRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :sms_ttrip_requests, id: :uuid do |t|
      t.string :phone_number
      t.string :sent_sms
      t.string :received_sms
      t.string :status
      
      t.uuid   :ttrip_request_id

      t.timestamps
    end
    add_index :sms_ttrip_requests, :ttrip_request_id
  end
end
