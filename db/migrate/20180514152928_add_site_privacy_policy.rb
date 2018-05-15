class AddSitePrivacyPolicy < ActiveRecord::Migration[5.2]
  def change
    add_column :sites, :privacy_policy_page_id, :integer

    add_foreign_key(
      :sites,
      :pages,
      column: :privacy_policy_page_id,
      name: 'fk__sites_privacy_policy_page_id'
    )
  end
end
