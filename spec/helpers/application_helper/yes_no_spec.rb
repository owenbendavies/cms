require 'rails_helper'

RSpec.describe ApplicationHelper, '#yes_no' do
  it 'shows yes for true' do
    expect(helper.yes_no(true)).to eq 'Yes'
  end

  it 'shows no for false' do
    expect(helper.yes_no(false)).to eq 'No'
  end
end
