module LoginAsTestHelpers
  def login_as(user)
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    # rubocop:enable RSpec/AnyInstance
  end

  def login_with_omniauth_as(user)
    OmniAuth.config.mock_auth[:'cognito-idp'] = OmniAuth::AuthHash.new(
      'uid' => user.id,
      'info' => {
        'name' => user.name,
        'email' => user.email
      },
      'extra' => { 'raw_info' => { 'cognito:groups' => user.groups } }
    )
  end
end

RSpec.configuration.include LoginAsTestHelpers, type: :feature
RSpec.configuration.include LoginAsTestHelpers, type: :request
