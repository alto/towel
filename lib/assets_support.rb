module AssetsSupport
  def create_or_update_from_uploaded_data(params, options={})
    return true if (params.nil? || params[:uploaded_data].blank?)
    !create(params.merge(options)).new_record?
  end
end