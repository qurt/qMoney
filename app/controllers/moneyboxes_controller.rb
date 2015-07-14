class MoneyboxesController < ApplicationController
  before_action :set_moneybox, only: [:show, :edit, :update, :destroy]

  # GET /moneyboxes
  # GET /moneyboxes.json
  def index
    @moneyboxes = Moneybox.all
  end

  # GET /moneyboxes/1
  # GET /moneyboxes/1.json
  def show
  end

  # GET /moneyboxes/new
  def new
    @moneybox = Moneybox.new
  end

  # GET /moneyboxes/1/edit
  def edit
  end

  # POST /moneyboxes
  # POST /moneyboxes.json
  def create
    @moneybox = Moneybox.new(moneybox_params)

    respond_to do |format|
      if @moneybox.save
        format.html { redirect_to @moneybox, notice: 'Moneybox was successfully created.' }
        format.json { render action: 'show', status: :created, location: @moneybox }
      else
        format.html { render action: 'new' }
        format.json { render json: @moneybox.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moneyboxes/1
  # PATCH/PUT /moneyboxes/1.json
  def update
    respond_to do |format|
      if @moneybox.update(moneybox_params)
        format.html { redirect_to @moneybox, notice: 'Moneybox was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @moneybox.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moneyboxes/1
  # DELETE /moneyboxes/1.json
  def destroy
    @moneybox.destroy
    respond_to do |format|
      format.html { redirect_to moneyboxes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_moneybox
      @moneybox = Moneybox.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def moneybox_params
      params.require(:moneybox).permit(:summary, :current, :percentage, :name)
    end
end
