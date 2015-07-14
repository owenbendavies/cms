require 'rails_helper'

RSpec.feature 'XML sitemap' do
  let!(:private_page) do
    FactoryGirl.create(
      :private_page,
      site: site,
      created_by: user,
      updated_by: user
    )
  end

  let(:go_to_url) { '/sitemap.xml' }

  scenario 'visiting the page' do
    visit_page go_to_url

    home_path = 'http://localhost/home'
    expect(find(:xpath, '//urlset/url[1]/loc').text).to eq home_path

    updated_at = test_page.updated_at.iso8601

    expect(find(:xpath, '//urlset/url[1]/lastmod').text).to eq updated_at

    expect(page).to have_no_xpath(
      '//loc',
      text: "http://localhost/#{private_page.url}"
    )
  end

  scenario 'visiting with https' do
    page.driver.header('X-Forwarded-Proto', 'https')
    visit_page go_to_url

    home_path = 'https://localhost/home'
    expect(find(:xpath, '//urlset/url[1]/loc').text).to eq home_path
  end
end
