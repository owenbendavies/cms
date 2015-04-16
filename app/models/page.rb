# == Schema Information
#
# Table name: pages
#
#  id            :integer          not null, primary key
#  site_id       :integer          not null
#  url           :string(64)       not null
#  name          :string(64)       not null
#  private       :boolean          default(FALSE), not null
#  contact_form  :boolean          default(FALSE), not null
#  html_content  :text
#  created_by_id :integer          not null
#  updated_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Page < ActiveRecord::Base
  INVALID_URLS = %w(health login logout new robots site sitemap timeout users)

  belongs_to :site
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  has_paper_trail

  strip_attributes except: :html_content, collapse_spaces: true

  auto_validate
  validates :url, exclusion: { in: INVALID_URLS }
  validates :name, length: { maximum: 64 }, uniqueness: { scope: :site_id }

  def name=(value)
    self.url = value.gsub("'", '').parameterize('_') if value
    super(value)
  end

  def to_param
    url_was
  end
end
