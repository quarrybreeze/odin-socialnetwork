class UserMailer < ApplicationMailer
  default from: "tprclayton@gmail.com"

  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(to: @user.email, subject: "Welcome to Social Network App")
  end
end
