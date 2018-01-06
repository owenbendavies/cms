require 'rails_helper'

RSpec.describe HealthPolicy do
  permissions :status? do
    it 'is permitted for everyone' do
      expect(described_class).to permit(context)
    end
  end
end
