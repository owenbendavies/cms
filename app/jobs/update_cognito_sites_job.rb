class UpdateCognitoSitesJob < ApplicationJob
  include Rails.application.routes.url_helpers

  def perform
    sites = Site.all
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
