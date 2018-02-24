RSpec.shared_examples 'email for site' do
  it 'has from address as site email' do
    expect(email.from).to eq [site.email]
  end

  it 'has from name as site name' do
    addresses = email.header['from'].address_list.addresses
    expect(addresses.first.display_name).to eq site.name
  end

  it 'has site name in body' do
    expect(email.body).to have_content site.name
  end

  context 'with site with copyright' do
    before { site.update!(copyright: new_name) }

    it 'has copyright in body' do
      expect(email.body).to have_content "#{new_name} © #{Time.zone.now.year}"
    end
  end

  context 'with site without copyright' do
    it 'has site name copyright in body' do
      expect(email.body).to have_content "#{site.name} © #{Time.zone.now.year}"
    end
  end

  context 'with site with charity number' do
    before { site.update!(charity_number: new_number) }

    it 'has charity number in body' do
      expect(email.body).to have_content "Registered charity number #{new_number}"
    end
  end

  context 'with site with charity number' do
    it 'does not have charity number in body' do
      expect(email.body).not_to have_content 'Registered charity'
    end
  end
end
