class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :stock_id
      t.integer :quantity
      t.decimal :total_amount

      t.timestamps
    end
  end
end
