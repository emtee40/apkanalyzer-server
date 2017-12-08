class MenusController < ApplicationController
  before_action :set_app_record
  before_action :set_app_record_asset, only: [:show]

  # GET /app_records/id/permission
  def index
    json_response(@app_record.assets)
  end

  # GET /app_records/id/@menu/id
  def show
    json_response(@menu)
  end

  def set_app_record
    @app_record = AppRecord.find(params[:app_record_id])
  end

  def set_app_record_asset
    @menu = @app_record.assets.find_by!(id: params[:id]) if @app_record
  end

end