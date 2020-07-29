class AnalyticsInfo
  TIME_FORMAT = '%Y-%m-%d'
  SECONDS_IN_A_DAY = 24 * 60 * 60

  PERIODS = [
    "last_3_days", "last_7_days", "last_30_days", "custom"
  ]

  DEFAULT_PERIOD = "last_3_days"

  class PeriodNotInformedOrCouldNotProccess < Exception ; end
  class StartOrEndDateEmptyException < Exception ; end
  class StartDateBiggerThanEndDateException < Exception ; end
  class DiffStartDateAndEndDateIsBiggerThan90Exception < Exception ; end

  attr_reader :period
  attr_accessor :start_date, :end_date

  def initialize domain, user
    @domain = domain
    @user = user
  end

  def period= period
    @period = period

    @end_date = DateTime.now.to_date

    if @period == "last_3_days"
      @start_date = 2.days.ago.to_date
    elsif @period == "last_7_days"
      @start_date = 6.days.ago.to_date
    elsif @period == "last_30_days"
      @start_date = 29.days.ago.to_date
    elsif @period == "custom"
      @start_date = nil
      @end_date = nil
    end

  end

  def fetch_info
    if self.respond_to? "fetch_#{period}"
      return self.send "fetch_#{period}"
    elsif self.respond_to? "fetch"
      return self.send "fetch"
    else
      raise PeriodNotInformedOrCouldNotProccess.new("Period #{period} wasn`t informed or could not be proccessed")
    end
  end


  def followers_evolution followers
    (@start_date..@end_date).step(1).map do |date|

      followers += rand(20)
      [date.strftime("%Y-%m-%d"), followers]
      # [date.strftime("%b/%d"), followers]
    end
  end

  def reach begin_reach
    (@start_date..@end_date).step(1).map do |date|
      begin_reach += rand(20)
      [date.strftime("%Y-%m-%d"), begin_reach]
      # [date.strftime("%b/%d"), begin_reach]
    end
  end

  def interactions_evolution begin_interactions
    (@start_date..@end_date).step(1).map do |date|

      begin_interactions += rand(20)
      [date.strftime("%Y-%m-%d"), begin_interactions]
      # [date.strftime("%b/%d"), begin_interactions]
    end
  end

  def gender multiplier
    male = rand(100) * multiplier
    female = rand(100) * multiplier
    unknown = rand(100) * multiplier
    total = male + female + unknown

    {
      total: total,
      male: male,
      female: female,
      unknown: unknown,
    }
  end

  def self.validate_start_and_end_dates start_date, end_date
    if not start_date.present? or not end_date.present?
      raise StartOrEndDateEmptyException.new("You must provide start_date and end_date when period is custom")
    end

    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    if end_date.to_datetime.to_i < start_date.to_datetime.to_i
      raise StartDateBiggerThanEndDateException.new("Start date is bigger than End date")
    end

    diff_days = (end_date.to_datetime.to_i / SECONDS_IN_A_DAY) - (start_date.to_datetime.to_i / SECONDS_IN_A_DAY)

    if diff_days > 90
      DiffStartDateAndEndDateIsBiggerThan90Exception.new(
        "Start date and end date must not be bigger than 90 days. Diff days is #{diff_days}")
    end

    [start_date, end_date]
  end

  def self.get_correct_period_and_validate_start_and_end_date period, start_date, end_date
    period ||= DEFAULT_PERIOD
    if not PERIODS.include? period
      period = DEFAULT_PERIOD
    end

    if period == "custom"
      start_date, end_date = validate_start_and_end_dates start_date, end_date
    end

    [period, start_date, end_date]
  end

end
