require 'rails_helper'

RSpec.describe ApplicationHelper, '#tick', type: :helper do
  it 'shows tick for true' do
    expect(tick(true)).to eq '<i class="fa fa-check"></i>'
  end

  it 'shows nothing when not true' do
    expect(tick(false)).to be_nil
  end
end
