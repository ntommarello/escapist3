PDFKit.configure do |config| 
  config.wkhtmltopdf = '/usr/local/bin/wkhtmltopdf' if Rails.env.development?
  config.wkhtmltopdf = Rails.root.join('bin', 'wkhtmltopdf').to_s if Rails.env.production?
  config.default_options = { 
    :print_media_type => true 
  } 
end