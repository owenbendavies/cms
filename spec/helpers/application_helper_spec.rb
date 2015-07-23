require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#body_id' do
    it 'uses path' do
      expect(body_id('/home')).to eq 'cms-page-home'
    end

    it 'changes / to -' do
      expect(body_id('/user/sites')).to eq 'cms-page-user-sites'
    end

    it 'removes edit' do
      expect(body_id('/home/edit')).to eq 'cms-page-home'
    end
  end

  describe '#page_title' do
    context 'site with sub title' do
      let(:site) do
        FactoryGirl.build(:site, sub_title: Faker::Company.catch_phrase)
      end

      context 'with content' do
        it 'shows title and content' do
          expect(page_title(site, new_name)).to eq "#{site.name} | #{new_name}"
        end
      end

      context 'blank content' do
        it 'shows title and sub title' do
          expect(page_title(site, '')).to eq "#{site.name} | #{site.sub_title}"
        end
      end

      context 'no content' do
        it 'shows title and sub title' do
          expect(page_title(site, nil)).to eq "#{site.name} | #{site.sub_title}"
        end
      end
    end

    context 'site without sub title' do
      let(:site) { FactoryGirl.build(:site) }

      context 'with content' do
        it 'shows title and content' do
          expect(page_title(site, new_name)).to eq "#{site.name} | #{new_name}"
        end
      end

      context 'no content' do
        it 'shows title' do
          expect(page_title(site, '')).to eq site.name
        end
      end
    end
  end

  describe '#footer_copyright' do
    let(:site) do
      FactoryGirl.build(
        :site,
        copyright: Faker::Name.name,
        charity_number: Faker::Number.number(Faker::Number.digit.to_i)
      )
    end

    context 'site with copyright and charity' do
      it 'includes copyright and charity number' do
        expect(footer_copyright(site)).to eq(
          "#{site.copyright} © #{Time.zone.now.year}. " \
          "Registered charity number #{site.charity_number}"
        )
      end
    end

    context 'site without copyright' do
      it 'uses site name for copyright' do
        site.copyright = nil

        expect(footer_copyright(site)).to eq(
          "#{site.name} © #{Time.zone.now.year}. " \
          "Registered charity number #{site.charity_number}"
        )
      end
    end

    context 'site without charity number' do
      it 'does not show charity number' do
        site.charity_number = nil
        footer = footer_copyright(site)

        expect(footer).to eq "#{site.copyright} © #{Time.zone.now.year}"
      end
    end

    context 'site without copyright or charity' do
      it 'does not show charity number' do
        site.copyright = nil
        site.charity_number = nil
        footer = footer_copyright(site)

        expect(footer).to eq "#{site.name} © #{Time.zone.now.year}"
      end
    end
  end

  describe '#tick' do
    it 'shows tick for true' do
      expect(tick('boolean', true)).to eq '<i class="boolean fa fa-check"></i>'
    end

    it 'shows nothing when not true' do
      expect(tick('boolean', false)).to be_nil
    end
  end
end
