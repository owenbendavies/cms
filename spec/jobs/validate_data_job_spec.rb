require 'rails_helper'

RSpec.describe ValidateDataJob do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:sysadmin) { FactoryGirl.create(:sysadmin) }

  it 'does not send an email with valid data' do
    FactoryGirl.create(:site)

    described_class.perform_now

    expect(ActionMailer::Base.deliveries.size).to eq 0
    Delayed::Worker.new.work_off
    expect(ActionMailer::Base.deliveries.size).to eq 0
  end

  it 'sends an email to sysadmins with invalid data' do
    site = FactoryGirl.create(:site)
    site.update_attribute(:name, 'x')

    message = FactoryGirl.create(:message)
    message.update_attribute(:name, 'y')

    described_class.perform_now

    expect(ActionMailer::Base.deliveries.size).to eq 0
    Delayed::Worker.new.work_off
    expect(ActionMailer::Base.deliveries.size).to eq 1

    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq [sysadmin.email]
    expect(email.subject).to eq 'ERROR on cms-test'

    expect(email.body.to_s).to eq <<EOF
The following models had errors

Message##{message.id}: Name is too short (minimum is 3 characters)
Site##{site.id}: Name is too short (minimum is 3 characters)
EOF
  end
end
