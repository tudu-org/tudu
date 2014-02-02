json.array!(@task) do |task|
  json.extract! task, :id, :start_time, :end_time, :deadline, :name, :description, :priority
  json.url task_url(task, format: :json)
end
