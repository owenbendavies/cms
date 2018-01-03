ActiveSupport::Notifications.subscribe('grape_api') do |_name, _start, _finish, _id, payload|
  attributes = {
    method: payload.fetch(:method),
    path: payload.fetch(:path),
    status: payload.fetch(:status),
    duration: payload.fetch(:time).fetch(:total),
    view: payload.fetch(:time).fetch(:view),
    db: payload.fetch(:time).fetch(:db),
    host: payload.fetch(:host),
    fwd: payload.fetch(:ip),
    user_agent: payload.fetch(:ua)
  }

  Rails.logger.info Lograge.formatter.call(attributes)
end
