class BajajsController < ApplicationController
  before_action :set_bajaj, only: [:show, :edit, :update, :destroy]

  # GET /bajajs
  # GET /bajajs.json
  def index
    @bajajs = Bajaj.all
  end

  # GET /bajajs/1
  # GET /bajajs/1.json
  def show
  end

  # GET /bajajs/new
  def new
    @bajaj = Bajaj.new
  end

  # GET /bajajs/1/edit
  def edit
  end

  # POST /bajajs
  # POST /bajajs.json
  def create
    @bajaj = Bajaj.new(bajaj_params)

    respond_to do |format|
      if @bajaj.save
        format.html { redirect_to @bajaj, notice: 'Bajaj was successfully created.' }
        format.json { render :show, status: :created, location: @bajaj }
      else
        format.html { render :new }
        format.json { render json: @bajaj.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bajajs/1
  # PATCH/PUT /bajajs/1.json
  def update
    respond_to do |format|
      if @bajaj.update(bajaj_params)
        format.html { redirect_to @bajaj, notice: 'Bajaj was successfully updated.' }
        format.json { render :show, status: :ok, location: @bajaj }
      else
        format.html { render :edit }
        format.json { render json: @bajaj.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bajajs/1
  # DELETE /bajajs/1.json
  def destroy
    @bajaj.destroy
    respond_to do |format|
      format.html { redirect_to bajajs_url, notice: 'Bajaj was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bajaj
      @bajaj = Bajaj.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bajaj_params
      params.require(:bajaj).permit(:first_name, :last_name, :number_plate, :phone_number, :stage, :status)
    end
end
