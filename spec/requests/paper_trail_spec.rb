require 'rails_helper'

RSpec.describe 'paper trail' do
  context 'when updating something' do
    let(:request_user) { FactoryBot.create(:user, site: site) }
    let(:request_method) { :put }
    let(:request_path) { '/site' }
    let(:request_params) { { 'site' => { 'name' => new_name } } }
    let(:expected_status) { 302 }

    it 'records who made the edit' do
      request_page

      site = Site.find_by!(name: new_name)
      expect(site.versions.last.whodunnit).to eq request_user.id.to_s
    end
  end
end
