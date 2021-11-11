class CreateTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :trades do |t|
      t.string :trade_type
      t.integer :quantity
      t.references :user, null: false, foreign_key: true
      t.references :user_stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
