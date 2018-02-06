require 'rails_helper'

RSpec.describe MessagePolicy do
  permissions :index? do
    include_examples 'user site policy'
  end

  permissions :show?, :destroy? do
    let(:record) { FactoryBot.create(:message, site: site) }

    include_examples 'user record policy'
  end
end
