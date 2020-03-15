after 'test:sites' do
  site = Site.find_by!(host: 'localhost')

  ('a'..'k').map do |i|
    Page.where(
      site: site,
      name: "Page #{i}"
    ).first_or_create!(
      html_content: "<p>#{Faker::Lorem.paragraph}</p>"
    )
  end
end
