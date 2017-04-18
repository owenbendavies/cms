require 'rails_helper'

RSpec.describe MessagePolicy do
  permissions :index? do
    let(:scope) { Message }

    include_examples 'user site policy'
  end

  permissions :show? do
    let(:scope) { FactoryGirl.create(:message, site: site) }

    include_examples 'user record policy'
  end
end
