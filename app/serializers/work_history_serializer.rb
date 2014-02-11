class WorkHistorySerializer < ActiveModel::Serializer
  attributes :id, :current_work, :title, :company, :date_started, :date_ended, :start_month, :start_year, :end_month, :end_year

  def start_month
    DateTime.parse(object.date_started).strftime('%m')
  end

  def start_year
    DateTime.parse(object.date_started).strftime('%Y')
  end

  def end_month
    DateTime.parse(object.date_ended).strftime('%m') if !object.date_ended.blank?
  end

  def end_year
    DateTime.parse(object.date_ended).strftime('%Y') if !object.date_ended.blank?
  end
end
