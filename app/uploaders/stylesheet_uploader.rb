class StylesheetUploader < BaseUploader
  def extension_white_list
    %w(css)
  end

  def store_dir
    'stylesheets'
  end
end
