class API < ApplicationAPI
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
  helpers ::Helpers::Params

  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :forbidden
  rescue_from Grape::Exceptions::ValidationErrors, with: :validation_errors
  rescue_from Pundit::NotAuthorizedError, with: :forbidden
  rescue_from :all, with: :unexpected_error

  namespace do
    before do
      PaperTrail.whodunnit = current_user.id if current_user
    end

    after(&:verify_authorized)

    mount MessagesAPI
    mount SnsNotificationsAPI
    mount SystemAPI
  end

  add_swagger_documentation(doc_version: 'v1', info: { title: 'obduk CMS API' })

  route :any, '*path' do
    page_not_found
  end
end
