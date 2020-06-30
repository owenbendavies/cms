module Mutations
  class UpdateSite < BaseMutation
    argument :site_id, ID, required: true, loads: Types::SiteType

    argument :charity_number, String, required: false
    argument :css, String, required: false
    argument :google_analytics, String, required: false
    argument :main_menu_in_footer, Boolean, required: false
    argument :name, String, required: false
    argument :separate_header, Boolean, required: false
    argument :sidebar_html_content, String, required: false

    field :errors, [Types::FieldErrors], null: true
    field :site, Types::SiteType, null: true

    def resolve(arguments)
      site = arguments.delete :site
      update_model(site, arguments)
    end
  end
end
