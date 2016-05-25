class Attachment < ActiveRecord::Base

  mount_uploader :data_file, DataFileUploader

  belongs_to :task

  validates :data_file, presence: true

  def image?
    data_file&.file&.content_type =~ %r{image\/.*}
  end

end
