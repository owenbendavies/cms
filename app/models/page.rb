# == Schema Information
#
# Table name: pages
#
#  id                 :integer          not null, primary key
#  site_id            :integer          not null
#  url                :string(64)       not null
#  name               :string(64)       not null
#  private            :boolean          default(FALSE), not null
#  contact_form       :boolean          default(FALSE), not null
#  html_content       :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  main_menu_position :integer
#
# Indexes
#
#  fk__pages_site_id                              (site_id)
#  index_pages_on_site_id_and_main_menu_position  (site_id,main_menu_position) UNIQUE
#  index_pages_on_site_id_and_url                 (site_id,url) UNIQUE
#
# Foreign Keys
#
#  fk_pages_site_id  (site_id => sites.id)
#

class Page < ActiveRecord::Base
  INVALID_URLS = %w(health login logout new robots site sitemap system user)

  acts_as_list scope: :site, column: :main_menu_position, add_new_at: nil

  belongs_to :site

  has_paper_trail

  strip_attributes except: :html_content, collapse_spaces: true

  validates :url, exclusion: { in: INVALID_URLS }

  def name=(value)
    self.url = value.delete("'").parameterize('_') if value
    super(value)
  end

  def to_param
    url_was
  end
end
