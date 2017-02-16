require 'rails_helper'

RSpec.describe 'GET /user/edit' do
  include_context 'authenticated page', :skip_unauthorized_check
end
