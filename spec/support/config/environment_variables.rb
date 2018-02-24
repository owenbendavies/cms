RSpec.configure do |config|
  config.around do |example|
    if defined? environment_variables
      ClimateControl.modify(environment_variables) do
        example.run
      end
    else
      example.run
    end
  end
end
