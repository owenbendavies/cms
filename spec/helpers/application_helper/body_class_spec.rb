require 'rails_helper'

RSpec.describe ApplicationHelper, '#body_class' do
  context 'when not signed in' do
    before do
      allow(helper).to receive(:user_signed_in?).and_return(false)
    end

    it 'uses path' do
      controller.request.path = '/home'
      expect(helper.body_class).to eq 'page-home'
    end

    it 'changes / to -' do
      controller.request.path = '/user/sites'
      expect(helper.body_class).to eq 'page-user-sites'
    end

    it 'adds class for edit edit' do
      controller.request.path = '/home/edit'
      expect(helper.body_class).to eq 'page-home page-home-edit'
    end
  end

  context 'when signed in' do
    before do
      allow(helper).to receive(:user_signed_in?).and_return(true)
    end

    it 'includes logged in' do
      controller.request.path = '/home'
      expect(helper.body_class).to eq 'cms-loggedin loggedin page-home'
    end
  end
end
