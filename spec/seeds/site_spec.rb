require 'rails_helper'

RSpec.describe 'Site seeds', type: :seed do
  shared_context 'creates site' do
    context 'with no site' do
      subject(:site) { Site.find_by(host: host) }

      it 'creates a site' do
        expect do
          generate_seeds
        end.to change(Site, :count).by 1
      end

      it 'sets the sites name' do
        generate_seeds
        expect(site.name).to eq 'New Site'
      end
    end

    context 'with a site matching the host' do
      before { FactoryGirl.create(:site, host: host) }

      it 'does not create a site' do
        expect do
          generate_seeds
        end.not_to change(Site, :count)
      end
    end
  end

  context 'with SEED_SITE_HOST set' do
    let(:host) { new_host }
    let(:environment_variables) { { SEED_SITE_HOST: new_host } }

    include_context 'creates site'
  end

  context 'with HEROKU_APP_NAME set' do
    let(:heroku_app_name) { Faker::Internet.domain_word }
    let(:host) { "#{heroku_app_name}.herokuapp.com" }
    let(:environment_variables) { { HEROKU_APP_NAME: heroku_app_name } }

    include_context 'creates site'
  end

  context 'without SEED_SITE_HOST or HEROKU_APP_NAME set' do
    it 'does not create a site' do
      expect do
        generate_seeds
      end.not_to change(Site, :count)
    end
  end
end
