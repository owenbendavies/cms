require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#body_class' do
    context 'without sigining in' do
      helper do
        def current_user
          nil
        end
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

    context 'with signed in' do
      helper do
        def current_user
          FactoryBot.build(:user)
        end
      end

      it 'includes logged in' do
        controller.request.path = '/home'
        expect(helper.body_class).to eq 'loggedin page-home'
      end
    end
  end

  describe '#copyright' do
    let(:site) { FactoryBot.build_stubbed(:site) }

    it 'uses site name' do
      expect(copyright(site)).to eq "#{site.name} © #{Time.zone.now.year}"
    end
  end

  describe '#icon_tag' do
    it 'renders an icon' do
      expect(helper.icon_tag('fas fa-icon fa-fw')).to eq '<i class="fas fa-icon fa-fw"></i>'
    end
  end

  describe '#page_title' do
    let(:site) { FactoryBot.build_stubbed(:site) }

    context 'with content' do
      it 'shows title and content' do
        expect(helper.page_title(site, new_name)).to eq "#{site.name} | #{new_name}"
      end
    end

    context 'without content' do
      it 'shows title' do
        expect(helper.page_title(site, nil)).to eq site.name
      end
    end
  end

  describe '#privacy_policy_link' do
    let(:site) { FactoryBot.create(:site, :with_privacy_policy) }
    let(:privacy_policy) { site.privacy_policy_page }

    it 'opens in a new page' do
      expect(helper.privacy_policy_link(site)).to include 'target="_blank" rel="noopener"'
    end

    context 'with url false' do
      it 'renders path link to privacy_policy' do
        expect(helper.privacy_policy_link(site)).to have_link(privacy_policy.name, href: "/#{privacy_policy.url}")
      end
    end

    context 'with url true' do
      it 'renders full url link to privacy_policy' do
        expect(helper.privacy_policy_link(site, url: true)).to have_link(
          privacy_policy.name,
          href: "http://test.host/#{privacy_policy.url}"
        )
      end
    end
  end

  describe '#site_stylesheet' do
    let(:css) { 'body{background-color: red}' }
    let(:md5) { 'b1192d422b8c8999043c2abd1b47b750' }
    let(:site) { FactoryBot.build(:site, css: css) }

    it 'returns stylesheet path' do
      url = "/css/#{md5}.css"

      expect(helper.site_stylesheet(site)).to eq url
    end
  end

  describe '#timeago' do
    let(:time) { '2018-05-06T17:48:38Z' }
    let(:short_time) { '06 May 17:48' }
    let(:expected_tag) { "<time class=\"js-timeago\" datetime=\"#{time}\">#{short_time}</time>" }

    it 'generates js-timeago tag' do
      expect(helper.timeago(Time.zone.parse(time))).to eq expected_tag
    end
  end

  describe '#yes_no' do
    it 'shows yes for true' do
      expect(helper.yes_no(true)).to eq 'Yes'
    end

    it 'shows no for false' do
      expect(helper.yes_no(false)).to eq 'No'
    end
  end
end
