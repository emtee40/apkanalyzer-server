class RepackagedDetectionQueriesService


  # filter initial dataset based on metrics which are hard to obfuscate
  # returns array of arrays [id, cert_md5] of such app records
  def filter_initial_dataset(app_record)
    AppRecord.where(:number_xmls => (app_record.number_xmls * 0.8).round..(app_record.number_xmls * 1.2).round,
                    :number_xmls_with_different_name => (app_record.number_xmls_with_different_name * 0.8).round..(app_record.number_xmls_with_different_name * 1.2).round,
                    :number_pngs => (app_record.number_pngs * 0.8).round..(app_record.number_pngs * 1.2).round,
                    :number_pngs_with_different_name => (app_record.number_pngs_with_different_name * 0.8).round..(app_record.number_pngs_with_different_name * 1.2).round,
                    :number_files_total => (app_record.number_files_total * 0.8).round..(app_record.number_files_total * 1.2).round,
                    :total_number_of_classes => (app_record.total_number_of_classes * 0.8).round..(app_record.total_number_of_classes * 1.2).round,
                    :total_number_of_classes_without_inner_classes => (app_record.total_number_of_classes_without_inner_classes * 0.8).round..(app_record.total_number_of_classes_without_inner_classes * 1.2).round)
                    .pluck(:id, :cert_md5)
  end

  def drawable_intersect_query(id_1, id_2)
    result = ActiveRecord::Base.connection.execute(" SELECT count(*)
    FROM (
             SELECT file_hash
    FROM drawables
    WHERE app_record_id = #{id_1}
    INTERSECT
    SELECT file_hash
    FROM drawables
    WHERE app_record_id = #{id_2}
    );")
    result[0][0]

    # res_2 = (Drawable.where(app_record_id: id_1) & (Drawable.where(app_record_id: id_1))).size
  end

  def drawable_union_query(id_1, id_2)
    Drawable.where(app_record_id: [id_1, id_2]).distinct('file_hash').count
  end

end