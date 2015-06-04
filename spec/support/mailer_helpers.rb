module MailerHelpers
  RSpec.shared_context 'site email' do
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

    it 'has copyright in body' do
      body = subject.body
      expect(body).to have_content "#{site.copyright} © #{Time.zone.now.year}"
    end
  end
end

RSpec.configuration.include MailerHelpers
