class SocialMetricsController < ApplicationController
  before_action :set_social_metric, only: [:show, :edit, :update, :destroy]

  # GET /social_metrics
  # GET /social_metrics.json
  def index
    @social_metrics = SocialMetric.last(200).reverse
  end

  # GET /social_metrics/1
  # GET /social_metrics/1.json
  def show
  end

  # GET /social_metrics/new
  def new
    @social_metric = SocialMetric.new
  end

  # GET /social_metrics/1/edit
  def edit
  end

  # POST /social_metrics
  # POST /social_metrics.json
  def create
    @social_metric = SocialMetric.new(social_metric_params)

    respond_to do |format|
      if @social_metric.save
        format.html { redirect_to @social_metric, notice: 'Social metric was successfully created.' }
        format.json { render action: 'show', status: :created, location: @social_metric }
      else
        format.html { render action: 'new' }
        format.json { render json: @social_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /social_metrics/1
  # PATCH/PUT /social_metrics/1.json
  def update
    respond_to do |format|
      if @social_metric.update(social_metric_params)
        format.html { redirect_to @social_metric, notice: 'Social metric was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @social_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /social_metrics/1
  # DELETE /social_metrics/1.json
  def destroy
    @social_metric.destroy
    respond_to do |format|
      format.html { redirect_to social_metrics_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_social_metric
      @social_metric = SocialMetric.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def social_metric_params
      params.require(:social_metric).permit(:context, :value, :minutes_since_publish, :post_id)
    end
end
