require 'spec_helper'

describe Features do
  subject { Features.new }

  it 'has accessors for its properties' do
    features = Features.new(edit_css: false)
    expect(features.edit_css).to eq false
  end

  it 'sets its id as features on save' do
    features = Features.new
    features.save!
    expect(features.id).to eq 'features'
  end
end
