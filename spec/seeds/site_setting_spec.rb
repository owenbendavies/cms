require 'rails_helper'

RSpec.describe 'Site setting seeds', type: :seed do
  context 'with SEED_SITE_HOST and SEED_USER_EMAIL set' do
    subject(:site_setting) do
      user = User.find_by(email: new_email)
      site = Site.find_by(host: new_host)
      SiteSetting.find_by(user: user, site: site)
    end

    let(:environment_variables) do
      {
        SEED_SITE_HOST: new_host,
        SEED_USER_EMAIL: new_email
      }
    end

    context 'with no site setting user or email' do
      it 'creates a site setting' do
        expect do
          generate_seeds
        end.to change(SiteSetting, :count).by 1
      end

      it 'sets site setting as admin' do
        generate_seeds
        expect(site_setting).to be_admin
      end
    end

    context 'with no site setting' do
      before do
        FactoryGirl.create(:user, email: new_email)
        FactoryGirl.create(:site, host: new_host)
      end

      it 'creates a site setting' do
        expect do
          generate_seeds
        end.to change(SiteSetting, :count).by 1
      end

      it 'sets site setting as admin' do
        generate_seeds
        expect(site_setting).to be_admin
      end
    end

    context 'with site setting' do
      before do
        user = FactoryGirl.create(:user, email: new_email)
        site = FactoryGirl.create(:site, host: new_host)
        FactoryGirl.create(:site_setting, user: user, site: site)
      end

      it 'does not create site setting' do
        expect do
          generate_seeds
        end.not_to change(SiteSetting, :count)
      end
    end
  end

  context 'with no SEED_SITE_HOST' do
    let(:environment_variables) { { SEED_USER_EMAIL: new_email } }

    it 'does not create site setting' do
      expect do
        generate_seeds
      end.not_to change(SiteSetting, :count)
    end
  end

  context 'with no SEED_USER_EMAIL' do
    let(:environment_variables) { { SEED_SITE_HOST: new_host } }

    it 'does not create site setting' do
      expect do
        generate_seeds
      end.not_to change(SiteSetting, :count)
    end
  end
end
