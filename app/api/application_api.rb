class ApplicationAPI < Grape::API
  def self.t(key, options = {})
    if key.first == '.'
      path = namespace.tr('/', '.').delete(':')
      key = ['api', path, key].join('.')
    end

    I18n.translate(key, options)
  end

  def self.paginate_with_max_per_page
    paginate per_page: 10, max_per_page: 100, enforce_max_per_page: true
  end
end
