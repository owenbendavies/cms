# == Schema Information
#
# Table name: pages
#
#  id            :integer          not null, primary key
#  site_id       :integer          not null
#  url           :string(64)       not null
#  name          :string(64)       not null
#  private       :boolean          default("false"), not null
#  contact_form  :boolean          default("false"), not null
#  html_content  :text
#  created_by_id :integer          not null
#  updated_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Page < ActiveRecord::Base
  INVALID_URLS = %w(health login logout new robots site sitemap timeout user)

  belongs_to :site
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  before_save do
    self.url = new_url
  end

  has_paper_trail

  strip_attributes except: :html_content, collapse_spaces: true

  validates *(attribute_names - ['html_content']), no_html: true
  validates :site_id, presence: true

  validates :name,
            presence: true,
            length: { maximum: 64 },
            uniqueness: { scope: :site_id }

  validates :created_by, presence: true
  validates :updated_by, presence: true

  validate do
    errors.add(:name) if new_url.blank? || INVALID_URLS.include?(new_url)
  end

  def new_url
    name.to_s.parameterize('_')
  end

  def to_param
    url
  end
end
