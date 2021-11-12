class TradesController < ApplicationController
  def new
    ticker_symbol = params[:ticker]
    @stock = Stock.check_db(ticker_symbol)
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

  def cart
    ticker_symbol = params[:ticker]
    @user_stock = UserStock.lookup(params[:user_stock_id])
    @stock = Stock.check_db(ticker_symbol)
    user_id = params[:user_id]
    user_stock_id = params[:user_stock_id]
    trade_type = params[:trade_type]
    quantity = params[:quantity]
    @trade = Trade.new(user_id: params[:user_id], user_stock_id: params[:user_stock_id], trade_type: params[:trade_type], quantity: params[:quantity])
    @total_price  = @stock.last_price * @trade.quantity
    render 'trades/new'
  end

  private
   def trade_params
    params.require(:trade).permit(:user_id, :user_stock_id, :trade_type, :quantity)
   end
end