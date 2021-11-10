class ApprovedMailer < ApplicationMailer
  def trader_approved
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome your account has been approved.
         You are now able to trade')
  end
end