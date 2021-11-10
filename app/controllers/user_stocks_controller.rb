class UserStocksController < ApplicationController
  
  def create
    stock = Stock.check_db(params[:ticker])
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash.now[:notice] = "Stock #{stock.name} successfully added to portfolio"
    redirect_to my_portfolio_path
  end

  def destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where( user_id: current_user.id, stock_id: stock.id).first
    user_stock.destroy
    flash[:alert] = "Stock removed from your portfolio"
    redirect_to my_portfolio_path
  end

  def edit
    # byebug
   @user_stock = UserStock.find(params[:id])
   @stock = Stock.find(params[:stock])
  end
end
