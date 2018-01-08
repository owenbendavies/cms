require 'rails_helper'

RSpec.describe HealthPolicy do
  permissions :status? do
    context 'without user or site' do
      let(:user) { nil }
      let(:site) { nil }

      it 'is permitted' do
        expect(described_class).to permit(context)
      end
    end
  end
end
