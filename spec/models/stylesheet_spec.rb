require 'rails_helper'

RSpec.describe Stylesheet do
  it_behaves_like 'model with versioning'

  describe 'relations' do
    it { is_expected.to belong_to(:site) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:site) }

    it { is_expected.to validate_presence_of(:css) }
  end
end
