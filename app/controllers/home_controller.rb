class HomeController < ApplicationController
  
  def index
    @categories = Category.all
	cookies[:current_word] = ""
	cookies[:attempt] = "0"
	cookies[:current_word] = ""
	session[:word_state] = ""
  end

end
