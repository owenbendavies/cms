require 'rails_helper'

RSpec.describe User do
  it 'has a gravatar_url' do
    user = build(:user, email: 'test@example.com')
    md5 = '55502f40dc8b7c769880b10874abc9d0'

    expect(user.gravatar_url).to eq "https://secure.gravatar.com/avatar/#{md5}.png?d=mm&r=PG&s=40"
  end
end
