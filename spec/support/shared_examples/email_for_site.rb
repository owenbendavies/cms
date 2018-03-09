RSpec.shared_examples 'email for site' do
  it 'has from address as site email' do
    expect(email.from).to eq [site.email]
  end

  it 'has message subject' do
    expect(email.subject).to eq expected_subject
  end

  it 'has site name in body' do
    expect(email.body).to have_content site.name
  end

  it 'has body' do
    expect(email.body).to have_content expected_body
  end
end
