require 'rails_helper'

RSpec.describe ApplicationHelper, '#timeago' do
  let(:time) { '2018-05-06T17:48:38Z' }
  let(:short_time) { '06 May 17:48' }
  let(:expected_tag) { "<time class=\"js-timeago\" datetime=\"#{time}\">#{short_time}</time>" }

  it 'generates js-timeago tag' do
    expect(helper.timeago(Time.zone.parse(time))).to eq expected_tag
  end
end
