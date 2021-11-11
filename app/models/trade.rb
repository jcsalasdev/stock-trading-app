class Trade < ApplicationRecord
  belongs_to :user
  belongs_to :user_stock
end
