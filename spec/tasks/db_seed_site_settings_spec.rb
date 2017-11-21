require 'rails_helper'

RSpec.describe 'db:seed:site_settings', type: :task do
  let(:environment_variables) do
    {
      SEED_SITE_HOST: new_host,
      SEED_USER_EMAIL: new_email
    }
  end

  context 'without site setting' do
    let!(:user1) { FactoryBot.create(:user, :sysadmin, email: new_email) }
    let!(:user2) { FactoryBot.create(:user, :sysadmin) }
    let!(:site1) { FactoryBot.create(:site, host: new_host) }
    let!(:site2) { FactoryBot.create(:site) }
    let(:other_user) { FactoryBot.create(:user) }

    before do
      allow(STDOUT).to receive(:puts)
        .with "Creating SiteSetting for #{user1.email} http://#{site1.host}"

      allow(STDOUT).to receive(:puts)
        .with "Creating SiteSetting for #{user1.email} http://#{site2.host}"

      allow(STDOUT).to receive(:puts)
        .with "Creating SiteSetting for #{user2.email} http://#{site1.host}"

      allow(STDOUT).to receive(:puts)
        .with "Creating SiteSetting for #{user2.email} http://#{site2.host}"
    end

    it 'creates a site setting for sysadmins' do
      expect do
        task.invoke
      end.to change(SiteSetting, :count).by 4
    end

    it 'sets seed user as site admin' do
      task.invoke
      expect(SiteSetting.find_by(user: user1, site: site1)).to be_admin
    end

    it 'sets sysadmins as site admin' do
      task.invoke
      expect(SiteSetting.find_by(user: user2, site: site2)).to be_admin
    end

    it 'does not create site setting for non sysadmins' do
      task.invoke
      expect(other_user.site_settings).to be_empty
    end
  end

  context 'with site setting' do
    before do
      user = FactoryBot.create(:user, :sysadmin, email: new_email)
      site = FactoryBot.create(:site, host: new_host)
      FactoryBot.create(:site_setting, user: user, site: site)
    end

    it 'does not create site setting' do
      expect do
        task.execute
      end.not_to change(SiteSetting, :count)
    end
  end
end
