class AddTotalPriceToTradesTable < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :total_price, :decimal
  end
end
