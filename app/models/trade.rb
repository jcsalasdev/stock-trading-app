class Trade < ApplicationRecord
  belongs_to :user
  belongs_to :user_stock

  validates :trade_type, :quantity, :user_id, :user_stock_id, :total_price, presence: true
end
