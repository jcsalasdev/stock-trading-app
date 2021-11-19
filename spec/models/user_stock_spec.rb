require 'rails_helper'

RSpec.describe UserStock, type: :model do

  context 'when validating user_stock associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:stock) }
  end
  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:stock_id) }
    it { is_expected.to validate_presence_of(:stock_quantity) }
  end

end
