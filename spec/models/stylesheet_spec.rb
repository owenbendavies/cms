# == Schema Information
#
# Table name: stylesheets
#
#  id         :integer          not null, primary key
#  site_id    :integer          not null
#  css        :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_stylesheets_on_site_id  (site_id) UNIQUE
#
# Foreign Keys
#
#  fk_stylesheets_site_id  (site_id => sites.id)
#

require 'rails_helper'

RSpec.describe Stylesheet do
  describe 'relations' do
    it { is_expected.to belong_to(:site) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:site) }

    it { is_expected.to validate_presence_of(:css) }
  end
end
