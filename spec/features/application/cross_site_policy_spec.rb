require 'rails_helper'

RSpec.feature 'Cross Site Policy' do
  scenario 'visiting a page' do
    visit_200_page '/home'

    expect(response_headers['Content-Security-Policy']).to eq [
      "default-src 'self' https:",
      "img-src 'self' https: data:",
      "script-src 'self' https: 'unsafe-inline'",
      "style-src 'self' https: 'unsafe-inline'"
    ].join('; ') + ';'
  end
end
