class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock
        respond_to do |format|
          format.js { render partial: 'users/result' }
        end
      else
        respond_to do |format|
          flash[:alert] = "Something went wrong."
          format.js { render partial: 'layouts/message' }
        end
      end
    else
      respond_to do |format|
        flash[:alert] = "Search can't be blank."
        format.js { render partial: 'layouts/message' }
      end
    end
  end
end