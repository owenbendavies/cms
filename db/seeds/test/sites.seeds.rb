Site.where(host: 'localhost').first_or_create!(
  email: 'test@example.com',
  name: 'New Site'
)
