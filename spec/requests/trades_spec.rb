require 'rails_helper'

RSpec.describe "Trades", type: :request do
  let(:stock) { create(:stock) }
  let(:user) { create(:user) }
  let(:user_stock) { UserStock.create(user_id: 1, stock_id: 1, stock_quantity: 10) }

  describe "new trade" do
    it "get to new trade)" do
      sign_in user
      get new_trade_path
      expect(response).to have_http_status(302)
    end
  end

  describe 'create trade' do
    before do
      sign_in user
      stock
    end

    it 'updates balance on buy' do
      post trades_path( :trade )
      expect(user.balance.to_f).to eq(97000.0)
    end

    it 'updates user_stock on buy' do
      user_stock
      post trades_path( :trade )
      expect(user_stock.stock_quantity).to eq(20)
    end


    it 'updates balance on sell' do
      post trades_path, params: { trade: { trade_type: 'sell', quantity: 10 , user_id: user.id , user_stock_id: 1 , total_price: 2000 } }
      expect(user.balance.to_f).to eq(101999.0)
    end

    it 'updates user_stock on sell' do
      user_stock
      post trades_path, params: { trade: { trade_type: 'sell', quantity: 10 , user_id: user.id , user_stock_id: 1 , total_price: 2000 } }
      expect(user_stock.stock_quantity).to eq(0)
    end
  end
end
