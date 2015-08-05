RSpec.configuration.before :each do |test|
  unless test.metadata[:secure_password]
    score = double('score')

    allow(score).to receive(:score).and_return(4)

    allow(Zxcvbn).to receive(:test).and_return(score)
  end
end
