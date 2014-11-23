# == Schema Information
#
# Table name: sites
#
#  id                    :integer          not null, primary key
#  host                  :string(64)       not null
#  name                  :string(64)       not null
#  sub_title             :string(64)
#  layout                :string(255)      default("one_column")
#  asset_host            :string(255)
#  main_menu_page_ids    :string(255)
#  copyright             :string(64)
#  google_analytics      :string(255)
#  charity_number        :string(255)
#  allow_search_engines  :boolean          default(TRUE)
#  stylesheet_filename   :string(32)
#  header_image_filename :string(32)
#  sidebar_html_content  :text
#  created_by_id         :integer          not null
#  updated_by_id         :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class DBSite < ActiveRecord::Base
  self.table_name = 'sites'

  belongs_to :created_by, class_name: 'DBAccount'
  belongs_to :updated_by, class_name: 'DBAccount'

  has_and_belongs_to_many :accounts,
    class_name: 'DBAccount',
    foreign_key: 'site_id',
    association_foreign_key: 'account_id'

  has_many :images, class_name: 'DBImage', foreign_key: 'site_id'
  has_many :messages, class_name: 'DBMessage', foreign_key: 'site_id'
  has_many :pages, class_name: 'DBPage', foreign_key: 'site_id'

  serialize :main_menu_page_ids, Array
end
