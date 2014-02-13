class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :set_category_by_name, only: [:play, :preparation]
  before_action :chceck_set_category, only: [:play]
  before_action :check_empty_current_word, only: [:play, :win, :fail]
  before_action :check_done_current_state, only: [:win]
  before_action :check_fail_permission, only: [:fail]
  
  # GET /preparation/1
  # GET /preparation/1.json
  def preparation
    session[:word_state] =""
	if @category.words.empty?
	  flash[:notice] = 'This category is empty'
      redirect_to root_path
	else
      flash[:notice] = ''
      current_word = @category.words.order("RANDOM()").first.content
	  cookies[:current_word] = current_word
      session[:word_state] ="_ "* current_word.length
	  cookies[:used_letters] = ""
	  cookies[:attempt] = "0"
	  redirect_to :action => 'play'	  
	end
	
  end
  
  # GET /play/1
  # GET /play/1.json
  def play
    current_letter = (params[:letter] || "")
	
    if cookies[:used_letters].include? current_letter
	else
	  cookies[:used_letters] = cookies[:used_letters] + current_letter
	end
	
	if !current_letter.empty?
	  match = false
	  for i in 0..cookies[:current_word].length
	    if cookies[:current_word][i] == current_letter
		  session[:word_state][i*2] = current_letter
		  match = true
		end
	  end
      if !match
	    cookies[:attempt] = (cookies[:attempt].to_i + 1).to_s 
      end
	end
	
	if session[:word_state].include? "_"
	else
	  redirect_to :action => 'win'	
	end
	if cookies[:attempt].to_i > 6
	  redirect_to :action => 'fail'	
	end
  end
  
  # GET /win/1
  # GET /win/1.json
  def win
  end
  
  # GET /fail/1
  # GET /fail/1.json
  def fail
  end
  
  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
	cookies[:current_word] = ""
	cookies[:attempt] = "0"
	cookies[:current_word] = ""
	session[:word_state] = ""
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
      authorize! :read, @category
  end

  # GET /categories/new
  def new
    @category = Category.new
	authorize! :create, @category
  end

  # GET /categories/1/edit
  def edit
    authorize! :update, @category 
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)
    authorize! :create, @category
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
  	authorize! :update, @category
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
  	authorize! :destroy, @category
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end
	
	def set_category_by_name
	  @category = Category.where('name = ?',params[:name]).first
	end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :icon)
    end
	
	def check_empty_current_word
	  if(cookies[:current_word] == nil || cookies[:current_word].empty? ||
	  session[:word_state] == nil || session[:word_state].empty?)
	    redirect_to root_path
      end
	end
	
	def check_done_current_state
	  if(cookies[:current_word] != session[:word_state])
	    if(cookies[:current_word] != nil && cookies[:current_word] != "")
	      redirect_to :action => 'play'	 
		  return
		end
	    redirect_to root_path
	  end
	end
	
	def check_fail_permission
	  if(cookies[:attempt].to_i != 7)
	    if(cookies[:current_word] != nil && cookies[:current_word] != "")
	      redirect_to :action => 'play'	 
		  return
		end
	    redirect_to root_path 
	  end
	end
	
	def chceck_set_category
	  if(@category == nil || @category == "")
	    redirect_to root_path
	  end
	end
end
