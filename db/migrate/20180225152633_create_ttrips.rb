class CreateTtrips < ActiveRecord::Migration[5.1]
  def change
    create_table :ttrips, id: :uuid do |t|
      t.string :status

      t.uuid   :ttrip_request_id

      t.timestamps
    end
     add_index :ttrips, :ttrip_request_id
  end
end
