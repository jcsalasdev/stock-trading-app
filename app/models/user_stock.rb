class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  has_many :trades
  validates :user_id, :stock_id, :stock_quantity, presence: true
  
  def self.lookup(id)
    find(id)
  end

  def self.update_db(params)
    
  end
end
