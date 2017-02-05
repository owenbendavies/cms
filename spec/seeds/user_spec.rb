require 'rails_helper'

RSpec.describe 'User seeds', type: :seed do
  context 'with SEED_USER_EMAIL set' do
    let(:environment_variables) { { SEED_USER_EMAIL: new_email } }

    context 'with no user' do
      subject(:user) { User.find_by(email: new_email) }

      it 'creates a user' do
        expect do
          generate_seeds
        end.to change(User, :count).by 1
      end

      it 'sets the users name' do
        generate_seeds
        expect(user.name).to eq 'System Administrator'
      end
    end

    context 'with a user matching the email' do
      before { FactoryGirl.create(:user, email: new_email) }

      it 'does not create a user' do
        expect do
          generate_seeds
        end.not_to change(User, :count)
      end
    end
  end

  context 'without SEED_USER_EMAIL' do
    it 'does not create a user' do
      expect do
        generate_seeds
      end.not_to change(User, :count)
    end
  end
end
