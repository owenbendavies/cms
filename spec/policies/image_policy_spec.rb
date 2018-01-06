require 'rails_helper'

RSpec.describe ImagePolicy do
  permissions :index? do
    include_examples 'user site policy'
  end
end
