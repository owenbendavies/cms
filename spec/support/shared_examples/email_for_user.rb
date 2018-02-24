RSpec.shared_examples 'email for user' do
  include_examples 'email for site'

  it 'is sent to users email' do
    expect(email.to).to eq [user.email]
  end

  it 'has users name' do
    expect(email.body).to have_content "Hi #{user.name}"
  end
end
