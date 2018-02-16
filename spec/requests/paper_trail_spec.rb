require 'rails_helper'

RSpec.describe 'paper trail' do
  context 'when updating something via the frontend' do
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

  context 'when creating something via the api' do
    let(:request_method) { :post }
    let(:request_path) { '/api/messages' }
    let(:request_user) { FactoryBot.create(:user, site: site) }
    let(:expected_status) { 201 }

    let(:request_params) do
      {
        'name' => new_name,
        'email' => new_email,
        'phone' => new_phone,
        'message' => new_message
      }
    end

    it 'records who created a model' do
      request_page

      message = Message.last
      expect(message.versions.last.whodunnit).to eq request_user.id.to_s
    end
  end
end
