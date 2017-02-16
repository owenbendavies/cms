require 'rails_helper'

RSpec.describe 'GET /site/css' do
  let(:authorized_user) do
    FactoryGirl.create(:user).tap do |user|
      user.site_settings.create!(site: site, admin: true)
    end
  end

  include_context 'authenticated page'
end
