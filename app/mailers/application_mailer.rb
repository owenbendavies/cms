class ApplicationMailer < ActionMailer::Base
  default template_path: 'mailers'
  helper :application
  layout 'mailer'

  protected

  def from_site(site)
    default_url_options.merge! site.url_options

    from = Mail::Address.new(site.email)
    from.display_name = site.name
    from
  end

  def to_users(site)
    (emails_for_group(site.host) + emails_for_group('admin')).sort
  end

  private

  def emails_for_group(group)
    AWS_COGNITO.list_users_in_group(
      user_pool_id: ENV.fetch('AWS_COGNITO_USER_POOL_ID'),
      group_name: group
    ).users.map do |user|
      user.attributes.find { |attribute| attribute.name == 'email' }.value
    end
  end
end
