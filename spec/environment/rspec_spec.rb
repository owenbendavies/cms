require 'rails_helper'

RSpec.describe RSpec do
  describe 'spec files' do
    it 'has correctly named files' do
      bad_files = Dir[Rails.root.join('spec/*/**/*.rb')] -
        Dir[Rails.root.join('spec/support/**/*.rb')] -
        Dir[Rails.root.join('spec/factories/**/*.rb')] -
        Dir[Rails.root.join('spec/*/**/*_spec.rb')]

      expect(bad_files).to eq []
    end
  end
end
