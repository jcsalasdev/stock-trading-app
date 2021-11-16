class TradesController < ApplicationController
  def index
    @trades = (current_user.role_id === 1) ? Trade.all.order('created_at DESC') : Trade.where(user_id: current_user.id).order('created_at DESC')
  end

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
    @user = current_user
    if @trade.save
        update_balance
        update_stock
        flash[:notice] = "trade was successfull"
        redirect_to my_portfolio_path
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
          user_stock = UserStock.find(params[:user_stock_id])
            if user_stock.stock_quantity
              user_stock.update(stock_quantity: user_stock.stock_quantity + @trade.quantity)
            else
              user_stock.update(stock_quantity: @trade.quantity)
            end
        when 'sell'
          user_stock = UserStock.find(params[:user_stock_id])
          if user_stock.stock_quantity
            user_stock.update(stock_quantity: user_stock.stock_quantity - @trade.quantity)
          else
            user_stock.update(stock_quantity: @trade.quantity)
          end
      end
      user_stock.save
  end
end