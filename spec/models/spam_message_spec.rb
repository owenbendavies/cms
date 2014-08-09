require 'rails_helper'

describe SpamMessage do
  include_context 'new_fields'

  it 'has accessors for its properties' do
    spam_message = SpamMessage.new(
      site_id: new_id,
      subject: new_name,
      name: new_name,
      email_address: new_email,
      phone_number: new_phone_number,
      message: new_message,
      do_not_fill_in: new_name,
      error_messages: {:field => ["error message"]},
    )

    expect(spam_message.site_id).to eq new_id
    expect(spam_message.subject).to eq new_name
    expect(spam_message.name).to eq new_name
    expect(spam_message.email_address).to eq new_email
    expect(spam_message.phone_number).to eq new_phone_number
    expect(spam_message.message).to eq new_message
    expect(spam_message.do_not_fill_in).to eq new_name
    expect(spam_message.error_messages).to eq({:field => ["error message"]})
  end
end
