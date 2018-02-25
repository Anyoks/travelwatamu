class CreateBtrips < ActiveRecord::Migration[5.1]
  def change
    create_table :btrips, id: :uuid do |t|
      t.string :status

       t.uuid   :btrip_request_id

      t.timestamps
    end
    add_index :btrips, :btrip_request_id
  end
end
