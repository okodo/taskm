# encoding: utf-8

class DataFileUploader < CarrierWave::Uploader::Base

  storage :file

  def store_dir
    "#{Rails.configuration.attachments_dir}/#{model.id}/original/"
  end

  def url
    "/attachments/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/cache/carrierwave/#{Rails.env}/"
  end

end
