# Be sure to restart your server when you modify this file.

Rails.application.config.session_store(
  :redis_store,
  expire_after: 30.days,
  key: '_cms_session',
  redis_server: Rails.application.secrets.redis_url
)
