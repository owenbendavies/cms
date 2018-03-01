require 'rails_helper'

RSpec.describe ApplicationHelper, '#icon_tag' do
  it 'renders an icon' do
    expect(helper.icon_tag('fas fa-icon fa-fw')).to eq '<i class="fas fa-icon fa-fw"></i>'
  end
end
