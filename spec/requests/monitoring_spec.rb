require 'rails_helper'

RSpec.describe 'Monitoring' do
  let(:scout_class) { ScoutApm::RequestManager.lookup }
  let(:scout_method) { :ignore_request! }

  context 'with GET /sitemap?monitoring=skip' do
    it 'skips Scout' do
      expect(scout_class).to receive(scout_method).and_call_original
      request_page
    end
  end

  context 'with GET /sitemap' do
    it 'does not skip Scout' do
      expect(scout_class).not_to receive(scout_method).and_call_original
      request_page
    end
  end
end
