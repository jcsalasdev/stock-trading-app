class TradesController < ApplicationController
  before_action :require_approved
  before_action :authenticate_user!
  before_action :require_trader, only: [:create, :new]
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
    if valid_quantity?
      if params[:trade_type] == "buy"
        if current_user.balance < total_price
          respond_to do |format|
            flash.now[:notice] = "You don't have enough balance for this transaction"
            format.js { render partial: 'layouts/message' }
          end
        else
          respond_to do |format|
            @trade = Trade.new(user_id: params[:user_id], user_stock_id: params[:user_stock_id], trade_type: params[:trade_type], quantity: params[:quantity], total_price: total_price)
            format.js { render partial: 'trades/cart' }
          end
        end
      else
        if UserStock.find(user_stock_id).stock_quantity < quantity.to_f
          respond_to do |format|
            flash[:notice] = "You don't have enough stocks for this transaction"
            format.js { render partial: 'layouts/message' }
          end
        else
          respond_to do |format|
            @trade = Trade.new(user_id: params[:user_id], user_stock_id: params[:user_stock_id], trade_type: params[:trade_type], quantity: params[:quantity], total_price: total_price)
            format.js { render partial: 'trades/cart' }
          end
        end
    
      end
    else
      respond_to do |format|
        flash[:notice] = "You have entered an invalid quantity"
            format.js { render partial: 'layouts/message' }
      end
    end
  end

  private

  def require_trader
    return if current_user.role_id === 2
    flash[:alert] = 'Access denied'
    redirect_to root_path
  end

  def require_approved
    return if current_user.status?
    flash[:alert] = 'Access denied'
    redirect_to root_path
  end

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

  def valid_quantity?
    !params[:quantity].blank? && params[:quantity].to_i != 0
  end
end