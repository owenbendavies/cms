require 'rails_helper'

RSpec.describe ImagePolicy do
  permissions :index? do
    let(:scope) { Image }

    include_examples 'user site policy'
  end
end
