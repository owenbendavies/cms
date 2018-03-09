require 'rails_helper'

RSpec.describe CustomDeviseMailer do
  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.create(:user, site: site) }
  let(:token) { rand(10_000) }

  describe '.confirmation_instructions' do
    subject(:email) { described_class.confirmation_instructions(user, token) }

    let(:expected_subject) { 'Confirmation instructions' }
    let(:expected_body) { 'Please confirm your email address.' }

    include_examples 'email for user'

    it 'has confirmation link in body' do
      link = "http://#{site.host}/user/confirmation?confirmation_token=#{token}"

      expect(email.body).to have_link 'Confirm Email', href: link
    end
  end

  describe '.password_change' do
    subject(:email) { described_class.password_change(user) }

    let(:expected_subject) { 'Password Changed' }
    let(:expected_body) { 'Your password has been changed' }

    include_examples 'email for user'
  end

  describe '.email_changed' do
    subject(:email) { described_class.email_changed(user) }

    let(:user) { FactoryBot.create(:user, :unconfirmed_email, site: site) }
    let(:expected_subject) { 'Email Changed' }
    let(:expected_body) { "email is being changed to #{user.unconfirmed_email}" }

    include_examples 'email for user'
  end

  describe '.reset_password_instructions' do
    subject(:email) { described_class.reset_password_instructions(user, token) }

    let(:expected_subject) { 'Reset password instructions' }
    let(:expected_body) { 'Someone has requested a link to change your password.' }

    include_examples 'email for user'

    it 'has reset password link in body' do
      link = "http://#{site.host}/user/password/edit?reset_password_token=#{token}"

      expect(email.body).to have_link 'Change password', href: link
    end
  end

  describe '.unlock_instructions' do
    subject(:email) { described_class.unlock_instructions(user, token) }

    let(:expected_subject) { 'Unlock instructions' }
    let(:expected_body) { 'Your account has been locked' }

    include_examples 'email for user'

    it 'has reset password link in body' do
      link = "http://#{site.host}/user/unlock?unlock_token=#{token}"

      expect(email.body).to have_link 'Unlock account', href: link
    end
  end

  describe '.invitation_instructions' do
    subject(:email) { described_class.invitation_instructions(user, token) }

    let(:inviter) { FactoryBot.create(:user) }
    let(:user) { FactoryBot.create(:user, invited_by: inviter, site: site, site_admin: true) }
    let(:expected_subject) { 'Invitation instructions' }
    let(:expected_body) { "You have been added to #{site.name} site by #{inviter.name}." }

    include_examples 'email for user'

    it 'has invite link in body' do
      link = "http://#{site.host}/user/invitation/accept?invitation_token=#{token}"

      expect(email.body).to have_link 'Confirm your account', href: link
    end
  end
end
