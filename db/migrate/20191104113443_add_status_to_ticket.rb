class AddStatusToTicket < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :status, :integer, null: false
  end
end
