# config/initializers/time_formats.rb
 Time::DATE_FORMATS[:day_month_year] = "%d %b %Y"
 Time::DATE_FORMATS[:weekday] = "%A"
 Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B {time.day.ordinalize}") }
