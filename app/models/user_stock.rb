class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  has_many :trades, dependent: :destroy
  validates :user_id, :stock_id, presence: true
  
  def self.lookup(id)
    find(id)
  end

  def self.update_db(params)
    
  end
end
