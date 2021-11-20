require 'rails_helper'

RSpec.describe Trade, type: :model do
  context 'validating trade associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:user_stock) }
  end

  context 'validating presence' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:user_stock_id) }
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_presence_of(:trade_type) }
    it { is_expected.to validate_presence_of(:total_price) }
  end

end
