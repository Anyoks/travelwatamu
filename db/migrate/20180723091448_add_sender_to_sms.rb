class AddSenderToSms < ActiveRecord::Migration[5.1]
  def change
    add_column :sms, :sender, :string
  end
end
