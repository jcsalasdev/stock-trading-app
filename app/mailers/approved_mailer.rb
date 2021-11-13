class ApprovedMailer < ApplicationMailer
  def trader_approved
    @email = params[:email]
    mail(to: @email, subject: 'Welcome to MyStock')
  end
end