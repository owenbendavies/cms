require 'rails_helper'

RSpec.describe ActiveRecord::Base, transaction: false do
  describe 'timeout' do
    it 'allows fast queries' do
      described_class.connection.execute('select pg_sleep(0.5);')
    end

    it 'fails on slow queries' do
      expect do
        described_class.connection.execute('select pg_sleep(2);')
      end.to raise_error(ActiveRecord::StatementInvalid, /statement timeout/)
    end
  end
end
