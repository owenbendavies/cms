SimpleForm.setup do |config|
  config.boolean_style = :inline
  config.browser_validations = true
  config.button_class = 'btn btn-primary'
  config.error_notification_class = 'alert alert-danger'

  config.wrappers :vertical_form, tag: 'div', class: 'form-group' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label

    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'form-text' }
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'form-group form-check' do |b|
    b.use :html5
    b.optional :readonly
    b.use :input, class: 'form-check-input'
    b.use :label, class: 'form-check-label'
    b.use :error, wrap_with: { tag: 'div', class: 'invalid-feedback d-block' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.default_wrapper = :vertical_form

  config.wrapper_mappings = { boolean: :vertical_boolean }
end
