require 'rails_helper'

RSpec.describe 'paper trail' do
  context 'when updating something' do
    let(:user) { FactoryBot.create(:user, site: site) }
    let(:request_method) { :put }
    let(:request_path) { '/site' }
    let(:request_params) { { 'site' => { 'name' => new_name } } }

    it 'records who made the edit' do
      request_page(expected_status: 302)

      site = Site.find_by!(name: new_name)
      expect(site.versions.last.whodunnit).to eq user.id.to_s
    end
  end
end
