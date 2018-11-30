module Mutations
  class UpdateSite < BaseMutation
    argument :site_id, ID, required: true, loads: Types::SiteType

    argument :name, String, required: false
    argument :google_analytics, String, required: false
    argument :charity_number, String, required: false
    argument :sidebar_html_content, String, required: false
    argument :main_menu_in_footer, Boolean, required: false
    argument :separate_header, Boolean, required: false

    field :errors, [Types::FieldErrors], null: true
    field :site, Types::SiteType, null: true

    def resolve(arguments)
      site = arguments.delete :site

      if site.update arguments
        { errors: [], site: site }
      else
        { errors: errors(site), site: nil }
      end
    end

    def errors(site)
      site.errors.messages.map do |field, messages|
        {
          'field' => field.to_s.camelize(:lower),
          'messages' => messages
        }
      end
    end
  end
end
