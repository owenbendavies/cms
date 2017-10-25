require 'rails_helper'

RSpec.describe 'GET /site/css' do
  let(:authorized_user) { FactoryBot.create(:user, site: site, site_admin: true) }

  include_examples 'authenticated page'
end
