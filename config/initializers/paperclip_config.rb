module ActiveRecord
  class Base
    def self.attachment_attrs(options = {})
      {
        :default_url       => "/images/no_pic.png",
        :storage           => :s3,
        :s3_credentials    => "#{Rails.root}/config/amazon_s3.yml",
        #:url              => "http://assets.escapist.me/:class/:attachment/:id/:style_:basename.:extension",
        :path              => ":attachment/:id/:style_:basename.:extension",
        :bucket            => "trek.io",
        :image_magick_path => "/usr/bin/",
        :s3_host_alias => "assets.escapist.me",
        :url => ":s3_alias_url",
        :whiny_thumbnails  => true,
        :default_style     => :thumb
      }.merge(options)
    end
  end
end