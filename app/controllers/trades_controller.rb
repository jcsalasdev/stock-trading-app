class TradesController < ApplicationController
  def new
    ticker_symbol = params[:ticker]
    @stock = Stock.check_db(ticker_symbol)
    @trade = Trade.new
    @user_stock = UserStock.lookup(params[:user_stock_id])
  end

  def create
    @trade = Trade.new(trade_type: params[:trade_type], quantity: params[:quantity], user_id: params[:user_id],
                        user_stock_id: params[:user_stock_id], total_price: params[:total_price])
    @trade.save
    flash[:notice] = "success"
    redirect_to my_portfolio_path
    @user = current_user
    # @trade = Trade.new(trade_params)
    if @trade.save
       flash[:notice] = "trade added"
        update_balance
    #   update_stock
    #   render 'trades/new'
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
    total_price = @stock.last_price * quantity.to_d
    @trade = Trade.new(user_id: params[:user_id], user_stock_id: params[:user_stock_id], trade_type: params[:trade_type], quantity: params[:quantity], total_price: total_price)
    # @total_price  = @stock.last_price * @trade.quantity
    render 'trades/new'
  end

  private

  def update_balance
    case @trade.trade_type
      when 'buy'
        @user.update(balance: current_user.balance - @trade.total_price)
      when 'sell'
        @user.update(balance: current_user.balance +  @trade.total_price)
    end
        @user.save
  end

  def update_stock
    case @trade.trade_type
      when 'buy'
        @user_stock.update(quantity: @user_stock.stock_quantity + @trade.quantity)
      when 'sell'
        @user_stock.update(quantity: @user_stock.stock_quantity - @trade.quantity)
        @user_stock.delete if @user_stock.quantity.zero?
    end
    @user_stock.save
  end
  #  def trade_params
  #   params.require(:trade).permit(:user_id, :user_stock_id, :trade_type, :quantity, :total_price)
  #  end
end