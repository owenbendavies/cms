require 'rails_helper'

RSpec.describe ApplicationHelper, '#body_id', type: :helper do
  it 'uses path' do
    expect(body_id('/home')).to eq 'cms-page-home'
  end

  it 'changes / to -' do
    expect(body_id('/user/sites')).to eq 'cms-page-user-sites'
  end

  it 'removes edit' do
    expect(body_id('/home/edit')).to eq 'cms-page-home'
  end
end
