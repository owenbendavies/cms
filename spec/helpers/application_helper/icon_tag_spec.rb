require 'rails_helper'

RSpec.describe ApplicationHelper, '#icon_tag' do
  it 'renders an icon' do
    expect(helper.icon_tag('icon')).to eq '<i class="fa fa-icon"></i>'
  end
end
