class PagesController < ApplicationController
    def home
        @stocks = Stock.all
        @home = Stock.most_active
    end
end