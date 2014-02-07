require 'spec_helper'

describe Features do
  subject { Features.new }

  describe 'properties' do
    its(:edit_css) { should eq true }
  end

  context 'when saved' do
    before do
      subject.save!
    end

    its(:id) { should eq 'features' }
  end
end
