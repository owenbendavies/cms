require 'rails_helper'

RSpec.describe 'db:seed:users', type: :task do
  context 'with SEED_USER_EMAIL set' do
    let(:environment_variables) do
      {
        SEED_USER_EMAIL: new_email
      }
    end

    context 'with no user' do
      before do
        expect(STDOUT).to receive(:puts).with "Creating User #{new_email}"
      end

      it 'creates a user' do
        expect do
          task.execute
        end.to change(User, :count).by 1
      end

      it 'sets the users name' do
        task.execute
        expect(User.find_by(email: new_email).name).to eq 'System Administrator'
      end
    end

    context 'with a user matching the email' do
      before { FactoryGirl.create(:user, email: new_email) }

      it 'does not create a user' do
        expect do
          task.execute
        end.not_to change(User, :count)
      end
    end
  end

  context 'without SEED_USER_EMAIL' do
    it 'raises an exception' do
      expect { task.execute }.to raise_error(
        ArgumentError,
        'SEED_USER_EMAIL environment variable not set'
      )
    end
  end
end
