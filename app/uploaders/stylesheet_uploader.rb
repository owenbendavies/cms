class StylesheetUploader < ApplicationUploader
  def extension_whitelist
    %w(css)
  end

  def store_dir
    'stylesheets'
  end
end
