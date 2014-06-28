require 'spec_helper'

describe SpamMessage do
  include_context 'new_fields'

  describe 'properties' do
    subject { Message.new(
      site_id: new_id,
      subject: new_name,
      name: new_name,
      email_address: new_email,
      phone_number: new_phone_number,
      message: new_message,
    )}

    its(:site_id) { should eq new_id }
    its(:subject) { should eq new_name }
    its(:name) { should eq new_name }
    its(:email_address) { should eq new_email }
    its(:phone_number) { should eq new_phone_number }
    its(:message) { should eq new_message }
  end
end
