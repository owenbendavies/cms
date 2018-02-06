class ApplicationAPI < Grape::API
  def self.t(key, options = {})
    if key.first == '.'
      path = namespace.tr('/', '.').delete(':')
      key = ['api', path, key].join('.')
    end

    I18n.translate(key, options)
  end
end
