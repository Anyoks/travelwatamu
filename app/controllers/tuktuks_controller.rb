class TuktuksController < ApplicationController
  before_action :set_tuktuk, only: [:show, :edit, :update, :destroy]

  # GET /tuktuks
  # GET /tuktuks.json
  def index
    @tuktuks = Tuktuk.all.sort_by { |book| book.available? ? 0 : 1 }.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /tuktuks/1
  # GET /tuktuks/1.json
  def show
  end

  # GET /tuktuks/new
  def new
    @tuktuk = Tuktuk.new
  end

  # GET /tuktuks/1/edit
  def edit
  end

  # POST /tuktuks
  # POST /tuktuks.json
  def create
    @tuktuk = Tuktuk.new(tuktuk_params)

    respond_to do |format|
      if @tuktuk.save
        format.html { redirect_to @tuktuk, notice: 'Tuktuk was successfully created.' }
        format.json { render :show, status: :created, location: @tuktuk }
      else
        format.html { render :new }
        format.json { render json: @tuktuk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tuktuks/1
  # PATCH/PUT /tuktuks/1.json
  def update
    respond_to do |format|
      if @tuktuk.update(tuktuk_params)
        format.html { redirect_to @tuktuk, notice: 'Tuktuk was successfully updated.' }
        format.json { render :show, status: :ok, location: @tuktuk }
      else
        format.html { render :edit }
        format.json { render json: @tuktuk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tuktuks/1
  # DELETE /tuktuks/1.json
  def destroy
    @tuktuk.destroy
    respond_to do |format|
      format.html { redirect_to tuktuks_url, notice: 'Tuktuk was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def make_available
    @tuktuk = Tuktuk.find(params[:tuktuk_id])
    available = @tuktuk.make_available
    if available
      respond_to do |format|
        format.html { redirect_to tuktuks_url, notice: 'Tuktuk is now available.' }
      end
      # format.json { render :show, status: :ok, location: @tuktuk }
    else
      respond_to do |format|
        format.html { redirect_to tuktuks_url, notice: 'Tuktuk has pending requests' }
      # format.json { render :show, status: :ok, location: @tuktuk }
      end
    end
  end

  def make_all_availble 
    @tuktuks = Tuktuk.where(status: false)

    @tuktuks.each do |tuktuk|
      tuktuk.make_available
    end

    respond_to do |format|
      format.html { redirect_to tuktuks_url, notice: 'Tuktuks are all now available.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tuktuk
      @tuktuk = Tuktuk.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tuktuk_params
      params.require(:tuktuk).permit(:first_name, :last_name, :number_plate, :phone_number, :stage, :status)
    end
end
