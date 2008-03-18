class Time
  def same_time_as?(time)
    format = '%d.%m.%Y-%H:%M'
    self.strftime(format) == time.strftime(format)
  end
  def same_date_as?(time)
    format = '%d.%m.%Y'
    self.strftime(format) == time.strftime(format)
  end
  def diff_in_minutes(time)
    diff_seconds = (self - time).abs.round
    diff_seconds / 60
  end
  def diff_in_hours(time)
    diff_in_minutes(time) / 60
  end
  def diff_in_days(time)
    diff_in_hours(time) / 24
  end
end
