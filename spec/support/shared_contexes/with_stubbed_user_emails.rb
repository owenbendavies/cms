RSpec.shared_context 'with stubbed user emails' do
  let(:email1) { Faker::Internet.email }
  let(:email2) { Faker::Internet.email }
  let(:user_emails) { [email1, email2] }

  let(:aws_cognito_user_data) do
    [
      {
        'attributes' => [
          { 'name' => 'email', 'value' => email1 }
        ]
      },
      {
        'attributes' => [
          { 'name' => 'email', 'value' => email2 }
        ]
      }
    ]
  end

  before do
    AWS_COGNITO.stub_responses(
      :list_users_in_group,
      AWS_COGNITO.stub_data(:list_users_in_group, users: aws_cognito_user_data)
    )
  end
end
