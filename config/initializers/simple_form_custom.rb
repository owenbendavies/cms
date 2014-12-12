SimpleForm.setup do |config|
  config.wrappers(
    :bootstrap3,
    tag: 'div',
    class: 'form-group',
    error_class: 'has-error'
  )do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label

    b.wrapper tag: 'div', class: 'col-control' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers(
    :wide,
    tag: 'div',
    class: 'form-group',
    error_class: 'has-error'
  ) do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label

    b.wrapper tag: 'div', class: 'col-control-wide' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.default_wrapper = :bootstrap3

  config.wrapper_mappings = { text: :wide }

  config.boolean_style = :inline
  config.browser_validations = true
  config.button_class = 'btn btn-primary'
  config.form_class = 'form-horizontal'
  config.input_class = 'form-control'
  config.label_class = 'control-label col-control-label'
  config.error_notification_class = 'alert alert-error'
end
