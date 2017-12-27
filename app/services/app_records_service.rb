class AppRecordsService


  def save_with_duplicate_check(app_record_params, upload_record_params,
                                permission_params, drawable_params)

    @app_record = get_if_exists app_record_params

    AppRecord.transaction do

      if @app_record.nil?
        @app_record = AppRecord.create! app_record_params

        @app_record.drawables.import drawable_params, validate: false
        @app_record.permissions.import permission_params, validate: false
      end

      if @app_record.upload_records.exists?(android_id: upload_record_params[:android_id])
        return nil
      end
      @app_record.upload_records.create!(upload_record_params)
    end

    @app_record
  end

  # Retrieve app record if exists. Hash based check.
  def get_if_exists(app_record_params)
    AppRecord.find_by_app_hash app_record_params[:app_hash]
  end
end