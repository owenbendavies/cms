require 'rails_helper'

RSpec.describe ApplicationHelper, '#tick' do
  it 'shows tick for true' do
    expect(helper.tick(true)).to eq '<i class="fas fa-check fa-fw"></i>'
  end

  it 'shows nothing when not true' do
    expect(helper.tick(false)).to be_nil
  end
end
