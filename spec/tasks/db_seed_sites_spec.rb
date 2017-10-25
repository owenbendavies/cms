require 'rails_helper'

RSpec.describe 'db:seed:sites', type: :task do
  shared_context 'creates site' do
    context 'with no site' do
      before do
        expect(STDOUT).to receive(:puts).with "Creating Site http://#{host}"
      end

      it 'creates a site' do
        expect do
          task.execute
        end.to change(Site, :count).by 1
      end

      it 'sets the sites name' do
        task.execute
        expect(Site.find_by(host: host).name).to eq 'New Site'
      end
    end

    context 'with a site matching the host' do
      before { FactoryBot.create(:site, host: host) }

      it 'does not create a site' do
        expect do
          task.execute
        end.not_to change(Site, :count)
      end
    end
  end

  context 'with SEED_SITE_HOST set' do
    let(:host) { new_host }

    let(:environment_variables) do
      {
        SEED_SITE_HOST: new_host
      }
    end

    include_examples 'creates site'
  end

  context 'with HEROKU_APP_NAME set' do
    let(:heroku_app_name) { Faker::Internet.domain_word }
    let(:host) { "#{heroku_app_name}.herokuapp.com" }

    let(:environment_variables) do
      {
        HEROKU_APP_NAME: heroku_app_name
      }
    end

    include_examples 'creates site'
  end

  context 'with SEED_SITE_HOST and HEROKU_APP_NAME set' do
    let(:heroku_app_name) { Faker::Internet.domain_word }
    let(:host) { new_host }

    let(:environment_variables) do
      {
        HEROKU_APP_NAME: heroku_app_name,
        SEED_SITE_HOST: new_host
      }
    end

    include_examples 'creates site'
  end

  context 'without SEED_SITE_HOST or HEROKU_APP_NAME set' do
    it 'raise an exception' do
      expect { task.execute }.to raise_error(
        ArgumentError,
        'SEED_SITE_HOST or HEROKU_APP_NAME environment variable not set'
      )
    end
  end
end
