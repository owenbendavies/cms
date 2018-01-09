class API < Grape::API
  use(
    GrapeLogging::Middleware::RequestLogger,
    instrumentation_key: 'grape_api',
    include: [GrapeLogging::Loggers::ClientEnv.new]
  )

  cascade false
  format :json

  helpers Pundit
  helpers ::Helpers::Authentication
  helpers ::Helpers::Errors

  rescue_from ActiveRecord::RecordNotFound, with: :forbidden
  rescue_from Pundit::NotAuthorizedError, with: :forbidden

  namespace do
    after(&:verify_authorized)

    mount ErrorsAPI
    mount HealthAPI
    mount MessagesAPI
    mount SnsNotificationsAPI
  end

  add_swagger_documentation(doc_version: 'v1', info: { title: 'obduk CMS API' })

  route :any, '*path' do
    page_not_found
  end
end
