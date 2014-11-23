# == Schema Information
#
# Table name: accounts
#
#  id              :integer          not null, primary key
#  email           :string(64)       not null
#  password_digest :string(64)       not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class DBAccount < ActiveRecord::Base
  self.table_name = 'accounts'

  has_and_belongs_to_many :sites,
    class_name: 'DBSite',
    foreign_key: 'account_id',
    association_foreign_key: 'site_id'
end
