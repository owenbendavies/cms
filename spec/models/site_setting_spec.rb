require 'rails_helper'

RSpec.describe SiteSetting do
  describe 'relations' do
    it { is_expected.to belong_to(:site) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    subject { FactoryBot.build :site_setting }

    it { is_expected.to validate_presence_of(:site) }
    it { is_expected.to validate_uniqueness_of(:site).scoped_to(:user_id) }

    it { is_expected.to validate_presence_of(:user) }
  end
end
