require 'rails_helper'

RSpec.describe 'PATCH /user' do
  include_context 'authenticated page', :skip_unauthorized_check
end
