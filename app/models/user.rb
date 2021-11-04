class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

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

end
