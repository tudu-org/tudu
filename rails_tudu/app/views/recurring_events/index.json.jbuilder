json.array!(@recurring_events) do |recurring_event|
  json.extract! recurring_event, :id, :recurring_start_time, :recurring_end_time, :start_time, :end_time, :every_monday, :every_tuesday, :every_wednesday, :every_thursday, :every_friday, :every_saturday, :every_sunday, :weeks_between, :name, :description
  json.url recurring_event_url(recurring_event, format: :json)
end
