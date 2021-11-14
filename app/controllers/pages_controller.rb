class PagesController < ApplicationController
    def home
        @stocks = Stock.all
        @home = Stock.most_active
        if user_signed_in? && current_user.role_id == 1
            redirect_to users_path
        end
    end
end