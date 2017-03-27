require 'rails_helper'

RSpec.describe 'GET /user/sites' do
  include_examples 'authenticated page', :skip_unauthorized_check
end
