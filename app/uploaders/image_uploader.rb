class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process :convert => 'jpeg'

  version :thumb do
    process :resize_to_fill => [50, 50]
  end
  
  version :frontpage do
    process :resize_to_fill => [200,200]
  end
  
  version :medium do
    process :resize_to_fit => [300, nil]
  end
  
  version :search do
    process :resize_to_fill => [150, 150]
  end
  
  def default_url
    "/images/default.png"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  # For heroku
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

end
