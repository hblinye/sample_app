class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :message
      t.string :to_account_name
      t.references :user, foreign_key: true

      t.timestamps
    end
    
    add_index :messages, [:user_id, :created_at]
  end
end
