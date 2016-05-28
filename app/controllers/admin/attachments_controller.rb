class Admin::AttachmentsController < ApplicationController

  before_action :require_authentication
  load_and_authorize_resource

  def show
    if @attachment.image?
      send_data File.open(@attachment.data_file.path, 'rb').read, type: @attachment.data_file.file.content_type, disposition: 'inline'
    else
      send_file @attachment.data_file.path, type: @attachment.data_file.file.content_type, filename: @attachment.data_file.file.filename, stream: false
    end
  end

end
