require 'rails_helper'

RSpec.describe ImagePolicy do
  permissions :index? do
    include_examples 'policy for site user'
  end
end
