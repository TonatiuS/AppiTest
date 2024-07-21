# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @users = Employee.new.call(:employee_list)
  rescue Employee::APIError, Employee::ConnectionError => e
    flash[:error] = e.message
    @users = []
  end
end
