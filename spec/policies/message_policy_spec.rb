require 'rails_helper'

RSpec.describe MessagePolicy do
  permissions :index? do
    include_examples 'policy for site user'
  end
end
