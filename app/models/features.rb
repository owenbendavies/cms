class Features
  include CouchModel

  property :edit_css, default: true

  set_callback :create, :before do
    self.id = 'features'
  end
end
