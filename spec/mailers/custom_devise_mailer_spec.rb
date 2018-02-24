require 'rails_helper'

RSpec.describe CustomDeviseMailer do
  let(:site) { FactoryBot.create(:site, host: 'localhost') }
  let(:user) { FactoryBot.create(:user, site: site) }
  let(:token) { rand(10_000) }

  describe '.confirmation_instructions' do
    subject(:email) { described_class.confirmation_instructions(user, token) }

    include_examples 'email for user'

    it 'has subject' do
      expect(email.subject).to eq 'Confirmation instructions'
    end

    it 'has text in body' do
      expect(email.body).to have_content 'Please confirm your email address.'
    end

    it 'has confirmation link in body' do
      link = "http://#{site.host}/user/confirmation?confirmation_token=#{token}"

      expect(email.body).to have_link 'Confirm Email', href: link
    end
  end

  describe '.password_change' do
    subject(:email) { described_class.password_change(user) }

    include_examples 'email for user'

    it 'has subject' do
      expect(email.subject).to eq 'Password Changed'
    end

    it 'has text in body' do
      expect(email.body).to have_content 'Your password has been changed'
    end
  end

  describe '.email_changed' do
    subject(:email) { described_class.email_changed(user) }

    let(:user) { FactoryBot.create(:user, :unconfirmed_email, site: site) }

    include_examples 'email for user'

    it 'has subject' do
      expect(email.subject).to eq 'Email Changed'
    end

    it 'has text in body' do
      expect(email.body).to have_content "email is being changed to #{user.unconfirmed_email}"
    end
  end

  describe '.reset_password_instructions' do
    subject(:email) { described_class.reset_password_instructions(user, token) }

    include_examples 'email for user'

    it 'has subject' do
      expect(email.subject).to eq 'Reset password instructions'
    end

    it 'has text in body' do
      expect(email.body).to have_content 'Someone has requested a link to change your password.'
    end

    it 'has reset password link in body' do
      link = "http://#{site.host}/user/password/edit?reset_password_token=#{token}"

      expect(email.body).to have_link 'Change password', href: link
    end
  end

  describe '.unlock_instructions' do
    subject(:email) { described_class.unlock_instructions(user, token) }

    include_examples 'email for user'

    it 'has subject' do
      expect(email.subject).to eq 'Unlock instructions'
    end

    it 'has text in body' do
      expect(email.body).to have_content 'Your account has been locked'
    end

    it 'has reset password link in body' do
      link = "http://#{site.host}/user/unlock?unlock_token=#{token}"

      expect(email.body).to have_link 'Unlock account', href: link
    end
  end

  describe '.invitation_instructions' do
    subject(:email) { described_class.invitation_instructions(user, token) }

    let(:inviter) { FactoryBot.create(:user) }
    let(:user) { FactoryBot.create(:user, invited_by: inviter, site: site, site_admin: true) }

    include_examples 'email for user'

    it 'has subject' do
      expect(email.subject).to eq 'Invitation instructions'
    end

    it 'has text in body' do
      expect(email.body).to have_content(
        "You have been added to #{site.name} site by #{inviter.name}."
      )
    end

    it 'has invite link in body' do
      link = "http://#{site.host}/user/invitation/accept?invitation_token=#{token}"

      expect(email.body).to have_link 'Confirm your account', href: link
    end
  end

  context 'with ssl is enabled' do
    subject(:email) { described_class.confirmation_instructions(user, token) }

    let(:environment_variables) { { DISABLE_SSL: nil } }

    it 'has https links' do
      expect(email.body).to have_link 'Confirm Email', href: %r{\Ahttps://#{site.host}/}
    end
  end
end
