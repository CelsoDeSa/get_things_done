json.extract! activity, :id, :name, :begin, :end, :finished, :project_id, :created_at, :updated_at
json.url activity_url(activity, format: :json)
