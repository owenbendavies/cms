# == Schema Information
#
# Table name: images
#
#  id            :integer          not null, primary key
#  site_id       :integer          not null
#  name          :string(64)       not null
#  filename      :string(36)       not null
#  created_by_id :integer          not null
#  updated_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class DBImage < ActiveRecord::Base
  self.table_name = 'images'

  belongs_to :site, class_name: 'DBSite'
  belongs_to :created_by, class_name: 'DBAccount'
  belongs_to :updated_by, class_name: 'DBAccount'
end
