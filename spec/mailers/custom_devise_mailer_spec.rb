require 'rails_helper'

RSpec.describe CustomDeviseMailer do
  include_context 'test site'

  let(:token) { rand(10_000) }

  describe '.confirmation_instructions' do
    subject { described_class.confirmation_instructions(site_user, token) }

    include_examples 'site email'

    it 'is sent to users email' do
      expect(subject.to).to eq [site_user.email]
    end

    it 'has subject' do
      expect(subject.subject).to eq 'Confirmation instructions'
    end

    it 'has users name' do
      expect(subject.body).to have_content "Hi #{site_user.name}"
    end

    it 'has text in body' do
      expect(subject.body).to have_content 'Please confirm your email address.'
    end

    it 'has confirmation link in body' do
      link = "http://#{site.host}/user/confirmation?confirmation_token=#{token}"

      expect(subject.body).to have_link 'Confirm Email', href: link
    end
  end

  describe '.password_change' do
    subject { described_class.password_change(site_user) }

    include_examples 'site email'

    it 'is sent to users email' do
      expect(subject.to).to eq [site_user.email]
    end

    it 'has subject' do
      expect(subject.subject).to eq 'Password Changed'
    end

    it 'has users name' do
      expect(subject.body).to have_content "Hi #{site_user.name}"
    end

    it 'has text in body' do
      expect(subject.body).to have_content 'Your password has been changed'
    end
  end

  describe '.reset_password_instructions' do
    subject { described_class.reset_password_instructions(site_user, token) }

    include_examples 'site email'

    it 'is sent to users email' do
      expect(subject.to).to eq [site_user.email]
    end

    it 'has subject' do
      expect(subject.subject).to eq 'Reset password instructions'
    end

    it 'has users name' do
      expect(subject.body).to have_content "Hi #{site_user.name}"
    end

    it 'has text in body' do
      expect(subject.body).to have_content 'Someone has requested a link to change your password.'
    end

    it 'has reset password link in body' do
      link = "http://#{site.host}/user/password/edit?reset_password_token=#{token}"

      expect(subject.body).to have_link 'Change password', href: link
    end
  end

  describe '.unlock_instructions' do
    subject { described_class.unlock_instructions(site_user, token) }

    include_examples 'site email'

    it 'is sent to users email' do
      expect(subject.to).to eq [site_user.email]
    end

    it 'has subject' do
      expect(subject.subject).to eq 'Unlock instructions'
    end

    it 'has users name' do
      expect(subject.body).to have_content "Hi #{site_user.name}"
    end

    it 'has text in body' do
      expect(subject.body).to have_content 'Your account has been locked'
    end

    it 'has reset password link in body' do
      link = "http://#{site.host}/user/unlock?unlock_token=#{token}"

      expect(subject.body).to have_link 'Unlock account', href: link
    end
  end

  describe '.invitation_instructions' do
    subject { described_class.invitation_instructions(invited_user, token) }

    let(:invited_user) do
      FactoryGirl.create(:user, invited_by: user) do |user|
        user.site_settings.create!(site: site, admin: true)
      end
    end

    include_examples 'site email'

    it 'is sent to users email' do
      expect(subject.to).to eq [invited_user.email]
    end

    it 'has subject' do
      expect(subject.subject).to eq 'Invitation instructions'
    end

    it 'has users name' do
      expect(subject.body).to have_content "Hi #{invited_user.name}"
    end

    it 'has text in body' do
      expect(subject.body).to have_content(
        "You have been added to #{site.name} site by #{user.name}."
      )
    end

    it 'has invite link in body' do
      link = "http://#{site.host}/user/invitation/accept?invitation_token=#{token}"

      expect(subject.body).to have_link 'Confirm your account', href: link
    end
  end

  context 'when ssl is enabled' do
    around do |example|
      ClimateControl.modify(DISABLE_SSL: nil) do
        example.run
      end
    end

    subject { described_class.confirmation_instructions(site_user, token) }

    it 'has https links' do
      expect(subject.body).to have_link 'Confirm Email', href: %r{\Ahttps://#{site.host}/}
    end
  end
end
