class Exercise < MotionDataWrapper::Model
  def self.performedOnDay(date)
    where("(performed_at >= ?) AND (performed_at < ?)", date.start_of_day, date.end_of_day)
  end
end
