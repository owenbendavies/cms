class CustomFailure < Devise::FailureApp
  def self.call(env)
    if env['ORIGINAL_FULLPATH'] == '/login'
      super
    else
      ApplicationController.action(:page_not_found).call(env)
    end
  end
end
