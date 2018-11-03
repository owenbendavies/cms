class UpdateCognitoSitesJob < ApplicationJob
  include Rails.application.routes.url_helpers

  def perform
    sites = Site.all
    update_cognito(sites)
    modify_groups(sites)
  end

  private

  def update_cognito(sites)
    AWS_COGNITO.update_user_pool_client(
      allowed_o_auth_flows: ['code'],
      allowed_o_auth_flows_user_pool_client: true,
      allowed_o_auth_scopes: ['openid'],
      callback_urls: callback_urls(sites),
      client_id: ENV.fetch('AWS_COGNITO_CLIENT_ID'),
      logout_urls: logout_urls(sites),
      supported_identity_providers: ['COGNITO'],
      user_pool_id: user_pool_id
    )
  end

  def callback_urls(sites)
    sites.map do |site|
      auth_cognito_idp_callback_url(site.url_options)
    end
  end

  def logout_urls(sites)
    sites.map do |site|
      root_url(site.url_options)
    end
  end

  def modify_groups(sites)
    expected_groups = %w[admin] + sites.map(&:host)
    existing_groups = cognito_groups

    add_missing_groups(expected_groups - existing_groups)
    remove_extra_groups(existing_groups - expected_groups)
  end

  def add_missing_groups(groups)
    groups.each do |group|
      AWS_COGNITO.create_group(
        group_name: group,
        user_pool_id: user_pool_id
      )
    end
  end

  def remove_extra_groups(groups)
    groups.each do |group|
      AWS_COGNITO.delete_group(
        group_name: group,
        user_pool_id: user_pool_id
      )
    end
  end

  def cognito_groups
    AWS_COGNITO.list_groups(user_pool_id: user_pool_id).groups.map(&:group_name)
  end

  def user_pool_id
    ENV.fetch('AWS_COGNITO_USER_POOL_ID')
  end
end
