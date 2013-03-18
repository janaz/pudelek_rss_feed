class Time
  def to_rfc3339
    base = self.strftime('%Y-%m-%dT%H:%M:%S')
    tz = self.strftime('%z')
    tz_rfc = "#{tz[0..2]}:#{tz[3..4]}"
    "#{base}#{tz_rfc}"
  end
end


