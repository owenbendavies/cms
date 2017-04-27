require 'rails_helper'

RSpec.describe ApplicationHelper, '#body_id' do
  it 'uses path' do
    expect(helper.body_id('/home')).to eq 'cms-page-home'
  end

  it 'changes / to -' do
    expect(helper.body_id('/user/sites')).to eq 'cms-page-user-sites'
  end

  it 'removes edit' do
    expect(helper.body_id('/home/edit')).to eq 'cms-page-home'
  end
end
