class ApplicationController < ActionController::Base

  def delete_resource_attached_file(resource, file_id)
    resource.files.find(file_id).purge   
  end
end
