class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
         
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :trades

  # has_many :transactions
  # has_many :stocks, through: :transactions
  
  validates :role_id, presence: true
  belongs_to :role

  before_validation :set_user_status
  def set_user_status
    if self.role_id == 1
      self.status = true
    else 
      self.status = false
    end
  end

  def stock_already_tracking?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def can_track?(ticker_symbol)
    !stock_already_tracking?(ticker_symbol)
  end

end
