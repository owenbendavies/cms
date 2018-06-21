require 'rails_helper'

RSpec.describe StylesheetPolicy do
  permissions :update? do
    let(:record) { FactoryBot.build(:stylesheet, site: site) }

    include_examples 'policy for site admin'
  end
end
