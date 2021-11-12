class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  has_many :trades

  def self.lookup(id)
    find(id)
  end
end
