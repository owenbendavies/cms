require 'spec_helper'

describe RSpec do
  describe 'spec files' do
    it 'has correctly named files' do
      bad_files = Dir[Rails.root.join('spec/*/**/*.rb')] -
        Dir[Rails.root.join('spec/support/**/*.rb')] -
        Dir[Rails.root.join('spec/factories/**/*.rb')] -
        Dir[Rails.root.join('spec/*/**/*_spec.rb')]

      bad_files.should eq []
    end
  end
end
