module ImageSupport
  def build_from_uploaded_data(params=nil)
    return true if (params.nil? || params[:uploaded_data].blank?)
    if self.is_a?(Array)
      !create(params).new_record?
    else
      self.update_attributes(params)
    end
  end  
end
