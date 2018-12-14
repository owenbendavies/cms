require 'rails_helper'

RSpec.describe 'paper trail' do
  include_context 'with test site'

  context 'when updating something via the frontend' do
    let(:request_user) { FactoryBot.build(:user, site: site) }
    let(:request_method) { :put }
    let(:request_path) { '/home' }
    let(:request_params) { { 'page' => { 'name' => new_name } } }
    let(:expected_status) { 302 }

    it 'records who made the edit' do
      request_page

      page = Page.find_by!(name: new_name)
      expect(page.versions.last.whodunnit).to eq request_user.id.to_s
    end
  end
end
