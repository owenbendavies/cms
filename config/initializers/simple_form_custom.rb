SimpleForm.setup do |config|
  config.error_notification_class = 'alert alert-danger'
  config.button_class = 'btn btn-primary'
  config.boolean_style = :inline

  config.wrappers(
    :bootstrap3,
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
    b.use :label, class: 'control-label col-control-label'

    b.wrapper tag: 'div', class: 'col-control' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint, wrap_with: { tag: 'p', class: 'help-block' }
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
    b.use :label, class: 'control-label col-control-label'

    b.wrapper tag: 'div', class: 'col-control-wide' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint, wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.default_wrapper = :bootstrap3
  config.wrapper_mappings = { text: :wide }
  config.browser_validations = true
  config.default_form_class = 'form-horizontal'
end
