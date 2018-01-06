require 'rails_helper'

RSpec.describe SnsPolicy do
  permissions :create? do
    it 'is permitted for everyone' do
      expect(described_class).to permit(context)
    end
  end
end
