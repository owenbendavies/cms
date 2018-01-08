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

  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  rescue_from Pundit::NotAuthorizedError, with: :page_not_found

  namespace do
    after(&:verify_authorized)

    mount ErrorsAPI
    mount HealthAPI
    mount MessagesAPI
  end

  add_swagger_documentation(doc_version: 'v1', info: { title: 'obduk CMS API' })

  route :any, '*path' do
    page_not_found
  end
end
