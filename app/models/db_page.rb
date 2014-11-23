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

class DBPage < ActiveRecord::Base
  self.table_name = 'pages'

  belongs_to :site, class_name: 'DBSite'
  belongs_to :created_by, class_name: 'DBAccount'
  belongs_to :updated_by, class_name: 'DBAccount'
end
