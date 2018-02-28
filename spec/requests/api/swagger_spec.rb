require 'rails_helper'

RSpec.describe 'GET /api/swagger' do
  before do
    request_page
  end

  it 'includes the title' do
    expect(json_body.fetch('info').fetch('title')).to eq 'obduk CMS API'
  end

  it 'includes the version' do
    expect(json_body.fetch('info').fetch('version')).to eq 'v1'
  end

  it 'includes definitions' do
    expect(json_body.fetch('definitions').keys).to include 'Message'
  end
end
