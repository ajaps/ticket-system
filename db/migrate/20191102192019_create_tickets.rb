class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.string :title, null: false
      t.text :text, null: false
      t.integer :priority
      t.references :user
      t.references :assignee
      t.timestamps
    end
  end
end
