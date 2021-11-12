class TradesController < ApplicationController
  def new
    @trade = Trade.new
    @user_stock = UserStock.lookup(params[:user_stock_id])
  end

  def create
    @user = current_user
   
    @trade = Trade.new(trade_params)
    if @trade.save
      flash[:notice] = "trade added"
      render 'trades/new'
    else
      render 'new'
    end
  end

  private
   def trade_params
    params.require(:trade).permit(:user_id, :user_stock_id, :trade_type, :quantity)
   end
end