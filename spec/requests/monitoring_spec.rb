require 'rails_helper'

RSpec.describe 'Monitoring' do
  let(:scout_class) { ScoutApm::RequestManager.lookup }
  let(:scout_method) { :ignore_request! }
  let(:new_relic_class) { NewRelic::Agent }
  let(:new_relic_method) { :ignore_transaction }

  context 'with GET /sitemap?monitoring=skip' do
    it 'skips Scout' do
      expect(scout_class).to receive(scout_method).and_call_original
      request_page
    end

    it 'skips NewRelic' do
      expect(new_relic_class).to receive(new_relic_method).and_call_original
      request_page
    end
  end

  context 'with GET /sitemap' do
    it 'does not skip Scout' do
      expect(scout_class).not_to receive(scout_method).and_call_original
      request_page
    end

    it 'does not skip NewRelic' do
      expect(new_relic_class).not_to receive(new_relic_method).and_call_original
      request_page
    end
  end
end
