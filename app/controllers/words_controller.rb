class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  # GET /words.json
  def index
    @words = Word.all
	authorize! :update, @category
  end

  # GET /words/1
  # GET /words/1.json
  def show
    authorize! :update, @category    
    redirect_to :back
  end

  # GET /words/new
  def new
    @word = Word.new
    authorize! :update, @category	
  end

  # GET /words/1/edit
  def edit
    authorize! :update, @category
  end

  # POST /words
  # POST /words.json
  def create
    authorize! :update, @category
    @word = Word.new(word_params)
    authorize! :update, @category
    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render action: 'show', status: :created, location: @word }
      else
        format.html { render action: 'new' }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    authorize! :update, @category
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word.destroy
	authorize! :update, @category
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
	  rescue ActiveRecord::RecordNotFound
        redirect_to root_url, :flash => { :error => "Record not found." }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:content, :category_id)
    end
end
