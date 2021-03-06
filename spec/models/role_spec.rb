require 'rails_helper'

RSpec.describe Role, type: :model do

  context 'validating presence' do
    it { is_expected.to validate_presence_of(:name)}
  end
  
end
