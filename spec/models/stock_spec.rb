require 'rails_helper'

RSpec.describe Stock, type: :model do
  context 'validating presence' do
    it { is_expected.to validate_presence_of(:ticker) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:last_price) }
  end

end
