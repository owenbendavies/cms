require 'rails_helper'

RSpec.describe ApplicationHelper, '#tick', type: :helper do
  it 'shows tick for true' do
    expect(tick('boolean', true)).to eq '<i class="boolean fa fa-check"></i>'
  end

  it 'shows nothing when not true' do
    expect(tick('boolean', false)).to be_nil
  end
end
