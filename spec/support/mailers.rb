RSpec.shared_context 'mailers' do
  def last_emails(expected_number)
    expect(ActionMailer::Base.deliveries.size).to eq 0
    Delayed::Worker.new.work_off
    expect(ActionMailer::Base.deliveries.size).to eq expected_number

    ActionMailer::Base.deliveries.pop(expected_number)
  end

  def last_email
    last_emails(1).first
  end

  before do
    ActionMailer::Base.deliveries = []
  end

  after do
    expect(ActionMailer::Base.deliveries.size).to eq 0
  end
end

RSpec.configuration.include_context 'mailers'

RSpec.shared_examples 'site email' do
  it 'has from address as site email' do
    expect(subject.from).to eq [site.email]
  end

  it 'has from name as site name' do
    addresses = subject.header['from'].address_list.addresses
    expect(addresses.first.display_name).to eq site.name
  end

  it 'has site name in body' do
    expect(subject.body).to have_content site.name
  end

  context 'site with copyright' do
    before { site.update!(copyright: new_name) }

    it 'has copyright in body' do
      expect(subject.body).to have_content "#{new_name} © #{Time.zone.now.year}"
    end
  end

  context 'site without copyright' do
    it 'has site name copyright in body' do
      expect(subject.body).to have_content "#{site.name} © #{Time.zone.now.year}"
    end
  end

  context 'site with charity number' do
    before { site.update!(charity_number: new_number) }

    it 'has charity number in body' do
      expect(subject.body).to have_content "Registered charity number #{new_number}"
    end
  end

  context 'site with charity number' do
    it 'does not have charity number in body' do
      expect(subject.body).not_to have_content 'Registered charity'
    end
  end
end

RSpec.shared_examples 'user email' do
  include_examples 'site email'

  it 'is sent to users email' do
    expect(subject.to).to eq [user.email]
  end

  it 'has users name' do
    expect(subject.body).to have_content "Hi #{user.name}"
  end
end
