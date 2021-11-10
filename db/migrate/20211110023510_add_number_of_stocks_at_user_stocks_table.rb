class AddNumberOfStocksAtUserStocksTable < ActiveRecord::Migration[6.1]
  def change
    add_column :user_stocks, :stock_quantity, :integer
  end
end
