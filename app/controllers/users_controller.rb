class UsersController < ApplicationController
  def index
    @users = User.includes(:followers).all
  end
end
